#!/usr/bin/env bash
# remove-coauthors.sh
#
# Removes all "Co-authored-by:" trailers from every commit in the repository
# using git-filter-repo. Preserves all timestamps (author and committer dates).
#
# Usage:
#   ./scripts/remove-coauthors.sh <git-repo-url> [--force]
#
# Arguments:
#   git-repo-url   The remote URL to set as origin after rewriting
#
# Options:
#   --force        Skip the confirmation prompt and run immediately
#   --push         Force-push all branches and tags after rewriting
#
# Prerequisites:
#   - git-filter-repo (https://github.com/newren/git-filter-repo)
#   - Python 3.6+
#   - git 2.36.0+
#
# What this script does:
#   1. Validates prerequisites (git-filter-repo, clean working tree)
#   2. Removes linked worktrees, prunes stale refs, deletes local-only branches
#   3. Counts existing Co-authored-by trailers
#   4. Runs git filter-repo --message-callback to strip them
#   5. Re-authors and re-signs all commits with your git identity
#   6. Adds the provided URL as remote origin
#   7. Verifies no Co-authored-by trailers remain
#
# After running this script, you will need to force-push:
#   git push origin --force --all
#   git push origin --force --tags

set -euo pipefail

# --- Colors and formatting ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { printf "${CYAN}[INFO]${RESET}  %s\n" "$*"; }
success() { printf "${GREEN}[OK]${RESET}    %s\n" "$*"; }
warn()    { printf "${YELLOW}[WARN]${RESET}  %s\n" "$*"; }
error()   { printf "${RED}[ERROR]${RESET} %s\n" "$*" >&2; }

# --- Parse arguments ---
FORCE=false
PUSH=false
REMOTE_URL=""

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=true ;;
    --push) PUSH=true ;;
    -h|--help)
      sed -n '2,/^$/{ s/^# //; s/^#//; p }' "$0"
      exit 0
      ;;
    -*)
      error "Unknown option: $arg"
      exit 1
      ;;
    *)
      if [ -z "$REMOTE_URL" ]; then
        REMOTE_URL="$arg"
      else
        error "Unexpected argument: $arg"
        exit 1
      fi
      ;;
  esac
done

if [ -z "$REMOTE_URL" ]; then
  error "Missing required argument: git-repo-url"
  echo ""
  echo "Usage: $0 <git-repo-url> [--force]"
  exit 1
fi

# --- Preflight checks ---
info "Running preflight checks..."

# Must be in a git repo
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  error "Not inside a git repository."
  exit 1
fi

# git-filter-repo must be installed
if ! command -v git-filter-repo &>/dev/null; then
  error "git-filter-repo is not installed."
  echo "  Install with: brew install git-filter-repo"
  exit 1
fi

# Working tree must be clean (ignoring untracked files)
if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
  error "Working tree has uncommitted changes. Commit or stash changes first."
  git status --short
  exit 1
fi

# --- Clean up worktrees and stale branches ---
info "Syncing with remote and cleaning up stale branches..."

# Ensure origin remote exists for fetch/prune (add temporarily if missing)
HAD_ORIGIN=true
if ! git remote get-url origin &>/dev/null; then
  HAD_ORIGIN=false
  git remote add origin "$REMOTE_URL"
fi

# Fetch latest state from remote and prune stale remote-tracking refs
git fetch origin --prune

# Remove linked worktrees (filter-repo cannot run with linked worktrees)
MAIN_WORKTREE="$(git worktree list --porcelain | head -1 | sed 's/^worktree //')"
WORKTREE_COUNT=0
while IFS= read -r line; do
  wt_path="$(echo "$line" | sed 's/^worktree //')"
  [ "$wt_path" = "$MAIN_WORKTREE" ] && continue
  info "Removing linked worktree: $wt_path"
  git worktree remove --force "$wt_path"
  WORKTREE_COUNT=$((WORKTREE_COUNT + 1))
done < <(git worktree list --porcelain | grep '^worktree ')

if [ "$WORKTREE_COUNT" -gt 0 ]; then
  success "Removed $WORKTREE_COUNT linked worktree(s)."
  # Clean up any stale worktree metadata
  git worktree prune
fi

# Delete local branches that no longer exist on the remote (skip current branch)
CURRENT_BRANCH="$(git branch --show-current)"
STALE_LOCAL=()
while IFS= read -r branch; do
  branch="$(echo "$branch" | sed 's/^[* ] //')"
  [ "$branch" = "$CURRENT_BRANCH" ] && continue
  if ! git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    STALE_LOCAL+=("$branch")
  fi
done < <(git branch --format='%(refname:short)')

if [ ${#STALE_LOCAL[@]} -gt 0 ]; then
  for branch in "${STALE_LOCAL[@]}"; do
    info "Deleting local branch with no remote: $branch"
    git branch -D "$branch"
  done
  success "Removed ${#STALE_LOCAL[@]} stale local branch(es)."
else
  success "No stale local branches found."
fi

# --- Gather info ---
REPO_ROOT="$(git rev-parse --show-toplevel)"
TOTAL_COMMITS="$(git log --all --oneline | wc -l | tr -d ' ')"
COAUTHOR_COUNT="$(git log --all --format='%b' | grep -ci 'Co-authored-by' || true)"

echo ""
printf "${BOLD}Repository:${RESET}      %s\n" "$REPO_ROOT"
printf "${BOLD}Remote URL:${RESET}      %s\n" "$REMOTE_URL"
printf "${BOLD}Current branch:${RESET}  %s\n" "$CURRENT_BRANCH"
printf "${BOLD}Total commits:${RESET}   %s\n" "$TOTAL_COMMITS"
printf "${BOLD}Co-author lines:${RESET} %s\n" "$COAUTHOR_COUNT"
echo ""

if [ "$COAUTHOR_COUNT" -eq 0 ]; then
  success "No Co-authored-by trailers found. Nothing to do."
  exit 0
fi

# --- Confirmation ---
if [ "$FORCE" = false ]; then
  warn "This will rewrite ALL commit SHAs in the repository."
  warn "A force-push will be required afterward."
  echo ""
  printf "${BOLD}Proceed? [y/N]:${RESET} "
  read -r CONFIRM
  if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    info "Aborted."
    exit 0
  fi
fi

echo ""

# --- Run git filter-repo ---
info "Stripping Co-authored-by trailers from all commits..."

git filter-repo --message-callback '
import re
# Remove Co-authored-by lines (case-insensitive to catch Co-Authored-By variants)
message = re.sub(rb"\nCo-authored-by:[^\n]*", b"", message, flags=re.IGNORECASE)
# Clean up any trailing whitespace left behind
message = message.rstrip() + b"\n"
return message
' --force

success "git filter-repo completed."

# --- Re-author and re-sign all commits ---
GIT_USER_NAME="$(git config user.name)"
GIT_USER_EMAIL="$(git config user.email)"
info "Re-authoring all commits as: $GIT_USER_NAME <$GIT_USER_EMAIL>"
info "Re-signing all commits (filter-repo strips signatures)..."

# Re-author, preserve timestamps, and sign every commit
git filter-branch -f --commit-filter '
  git commit-tree -S "$@"
' --env-filter '
  export GIT_AUTHOR_NAME="'"$GIT_USER_NAME"'"
  export GIT_AUTHOR_EMAIL="'"$GIT_USER_EMAIL"'"
  export GIT_COMMITTER_NAME="'"$GIT_USER_NAME"'"
  export GIT_COMMITTER_EMAIL="'"$GIT_USER_EMAIL"'"
  export GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
' -- --all

# Clean up filter-branch backup refs
git for-each-ref --format="delete %(refname)" refs/original/ | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now

success "All commits re-authored and re-signed."

# --- Add remote ---
# filter-repo removes all remotes; re-add origin with the provided URL
info "Adding remote origin: $REMOTE_URL"
if git remote get-url origin &>/dev/null; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi
success "Remote origin set."

# --- Verify ---
echo ""
info "Verifying..."

REMAINING="$(git log --all --format='%b' | grep -ci 'Co-authored-by' || true)"

if [ "$REMAINING" -eq 0 ]; then
  success "All Co-authored-by trailers have been removed."
else
  error "$REMAINING Co-authored-by trailers still remain!"
  exit 1
fi

NEW_TOTAL="$(git log --all --oneline | wc -l | tr -d ' ')"
info "Commits before: $TOTAL_COMMITS | Commits after: $NEW_TOTAL"

echo ""
if [ "$PUSH" = true ]; then
  info "Force-pushing all branches and tags..."
  git push origin --force --all
  git push origin --force --tags
  success "Pushed rewritten history to origin."
else
  success "Done! To push the rewritten history:"
  echo ""
  echo "  git push origin --force --all"
  echo "  git push origin --force --tags"
fi
echo ""
warn "All collaborators will need to re-clone or reset their local copies."
