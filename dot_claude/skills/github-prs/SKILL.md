---
name: github-prs
description: Use when creating a GitHub pull request, writing or editing a PR description, or posting comments or reviews on GitHub PRs and issues, including inline review comments.
---

# GitHub PRs and Comments

## Comments and reviews

- When posting comments on GitHub (issues, PRs, etc.), always sign off to indicate Claude posted
  it, not the user directly. A simple sign-off like "posted by Claude Code" suffices.
- Never post PR comments one by one. Each one fires a notification and bombards the PR author.
  Batch them into a single GitHub review and leave that review pending (not submitted), so I can
  inspect the comments before submitting it myself.
- When an inline review comment suggests a specific code change, include it as a GitHub
  suggestion snippet (a ```suggestion fenced block with the replacement code) so it can be
  applied with one click, not just described in prose.
- Keep PR comments brief and in plain, simple wording: state the issue and the fix, skip lengthy
  prose and rationale.

## Creating a PR

- When the AI agent did most of the implementation, apply the label `> 90% ai generated`
  (`gh pr create --label "> 90% ai generated"`). If the repo has no such label, tell me instead
  of creating it.
- Write PR descriptions with clean hierarchical structure (headings, bullet points) instead of
  heavy paragraph prose. Use emoji to label/categorize sections, for example 🐛 for a bug fix,
  ✨ for a feature, ⚠️ for a breaking change.
- If the repo's PR template uses `>` blockquotes, those are the template's own instructional
  notes, not a formatting style to carry into the filled-in content.

## Editing a PR description

- Before editing, fetch the current body (`gh pr view --json body`) and keep every screenshot,
  image, and video in it. Edit around them, never drop them.
- Keep the description accurate: if the branch changes after the description was written,
  update it to match before asking for review.
