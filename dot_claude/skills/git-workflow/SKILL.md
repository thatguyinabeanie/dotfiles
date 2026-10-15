---
name: git-workflow
description: Use when committing, pushing, branching, or opening a PR as part of a coding task, and when checking CI status or troubleshooting CI failures, including CircleCI.
---

# Git Workflow

## Commits and pushes

- Commit often, in small logical chunks. Commit messages should be brief but detailed: precise
  and direct, no fluff, explaining why not just what.
- Push less often than you commit, but still somewhat regularly. Don't let a branch sit
  unpushed for an entire task.
- Open a PR early, as soon as a branch exists remotely and there's something to review, if one
  doesn't already exist. Draft/WIP PRs are fine. Use the `github-prs` skill for the PR itself.

## CI

- Prefer letting CI run lint/tests in the cloud over re-running them locally every time. After
  pushing, check CI status periodically instead of blocking synchronously on it, and use the
  freed-up time to keep working on other parts of the task.
- Guideline, not a hard rule: let an in-flight CI run finish before pushing again to the same
  branch/PR. Many CI systems cancel the current run when a new push lands on the same ref, so
  pushing mid-run usually wastes that run. Push right away when the in-flight run's result no
  longer matters, for example when it's already stale or covers a change you're superseding.
- For CircleCI questions or CI troubleshooting, use the CircleCI MCP tools instead of the
  `circleci` CLI. No `CIRCLECI_TOKEN` needed, the MCP server handles auth.
