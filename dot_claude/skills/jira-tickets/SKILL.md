---
name: jira-tickets
description: Use when drafting, creating, editing, commenting on, or transitioning a Jira ticket (issue, story, bug, task, epic), including turning an investigation, bug report, or Slack thread into a ticket.
---

# Jira Tickets

Jira tickets are read by people, not agents. Write them so a teammate can skim the ticket and
know what it is, why it matters, and what "done" looks like.

## Before touching Jira

- Show me the full draft (title, fields, description) and wait for my OK before creating or
  editing anything in Jira.
- Ask me for issue type, priority, epic, labels, and assignee when I haven't given them.
  Don't guess.

## Writing the ticket

- Optimize for a teammate skimming the ticket: clear headings, short sections, bullet points.
  Technical terms are fine when they don't hurt readability; define or link anything a reader
  outside the immediate work might not know.
- Title: short, specific, and searchable. Start with a verb for tasks ("Add retry to export
  job"); describe the observable behavior for bugs ("Export job fails on empty tables").
- Structure the description in this order, skipping sections that don't apply:
  - **Summary**: one or two sentences on what the ticket is about. A reader should get the gist
    from this alone.
  - **Background**: context needed to understand the work: why it matters now, who it
    affects, how we got here.
  - **Problem / Goal**: what is wrong or what needs to happen. Be concrete ("do A, B, and C"),
    not vague ("improve X"). For bugs, include numbered steps to reproduce plus expected vs
    actual behavior.
  - **Technical details** (optional): pointers that help whoever picks up the ticket get started.
    - Files, functions, or modules to look at or likely to change, by repo-relative path (for
      example `app/models/export_job.rb:42`). Mark each one as either to read or likely to
      change. Not every path needs a link; decide per reference:
      - **Plain path** when a link adds nothing: a passing mention, a file the reader already
        has open from another link, a long list of similar files, or a path that only exists
        locally or is generated.
      - Otherwise make it a GitHub link with the path as the link text, using one of the two
        types below.
      - **Permalink** (pinned to a commit) when the reference points at specific lines or code
        as it is now: a bug location, a quoted snippet, a stack trace frame. Line numbers drift
        on the default branch, so these need a pin.
      - **Default branch link** when the reference points at a whole file or module that the
        work will change. The reader wants the current version, not a snapshot.
      - Build them with `gh browse <path>:<line> -n` (default branch) or add
        `--commit=<sha>` (permalink). Use a SHA that exists on the remote, such as
        `git rev-parse origin/main`, never a local-only commit.
    - Short code snippets, error messages, stack traces, or log excerpts in code blocks, trimmed
      to the relevant lines.
    - Commands to reproduce or inspect (queries, CLI calls), plus relevant config, flags, or
      environment details.
    - Label pointers that came from a quick look as starting points, not a confirmed list.
    - Never include secrets or PII.
  - **Acceptance criteria**: a checklist of specific, testable conditions that mark the ticket
    as done. Each item should be verifiable as true or false.
  - **Open questions**: decisions still pending or facts not yet confirmed, with who can answer
    them if known.
  - **Out of scope** (optional): related work this ticket deliberately does not cover.
  - **Links**: related tickets, PRs, Slack threads, docs.
- Describe what and why, not how. Pointing at where the work lives (Technical details) is fine;
  include an implementation approach only when it has already been decided, and say so.
- Label anything unverified (for example `likely` or `about 2 clients, unconfirmed`) instead of
  stating it as fact.
- Keep it tight: no filler, and don't repeat the Summary in later sections.
- Keep one ticket to one deliverable. If it grows multiple independent goals, propose
  splitting it.

## Updating an existing ticket

- Fetch it first and keep every attachment, image, and link.
- When changing status (especially to Blocked), add a comment saying why.
- When closing, add a short comment summarizing what was done.

## Final check

Before posting: could a teammate tell what this is, why it matters, and what "done" looks like
within a quick read?
