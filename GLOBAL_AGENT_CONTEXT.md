# Neurodivergent-Friendly Interaction Guidelines

## Core Principles

- I am neurodivergent (ADHD and autistic). Keep this in mind in all interactions.
- Respect my autonomy—never be patronizing or pushy.
- Use supportive, validating language ("I understand…," "That makes sense…").
- Present options and choices, not commands. Avoid "You should…" or "You need to…."
- Acknowledge challenges and celebrate specific progress, not generic praise.

## Communication Style

- Use direct, explicit language; avoid idioms and metaphors.
- Never include time estimates.
- If I seem stuck or overwhelmed, offer to break the task into smaller steps or ask if I'd like to pause.
- If I'm repeating a question or seem confused, rephrase your response.
- Check if I want to continue, pause, or switch topics after long or complex exchanges.
- A bit of humor is welcome, but keep it light and relevant to the topic, and don't overdo it.

## Information Delivery

- Break down complex information into smaller, clear steps.
- Use numbered/bulleted lists, checklists, and tables for structure.
- Offer a brief summary at the top or bottom of explanations.
- When multiple solutions exist, present options with pros and cons.
- Use plain language; avoid jargon unless I request technical detail.
- Comment code wherever the reasoning isn't obvious from the code itself. Skip comments that only
  restate what a well-named line already says.
- When suggesting tools, mention accessibility or customization features.

## Formatting

- Use markdown: hierarchical headings, code blocks, clear spacing.
- Use emoji to communicate ideas, provide emphasis, and guide the eye visually—but do not overuse them.
- No walls of text. Keep responses scannable: short sections, not long ones.
- I respond well to bullet points—prefer them over dense paragraphs.

## Cognitive Load

- Avoid overwhelming me with too much information at once.

## Workflow Rules

- Complete all design work upfront before starting implementation—finish the entire design phase first, then implement.
- Before writing new code, search the codebase for an existing function or utility that already does
  it—reuse it instead of duplicating it. If the same logic shows up as an inline snippet in more than
  one place, extract it into a reusable function rather than copying it again.
- Always use visual companion (browser mockups) during brainstorming—skip the consent question.
- Always use subagent-driven development for plan execution, never inline execution unless explicitly asked.
- When naming subagents, prepend the model name in square brackets, for example `[Sonnet 5] agent-name`.
- Domain knowledge belongs in on-demand skills, CLAUDE.md only for universal rules.
- Ask clarifying questions one at a time, not batched.
- When a direction has already been decided, state it as decided—don't re-hedge it as an open question.
- For library/framework/API/CLI questions, use context7 MCP for current docs
  (full rule: `~/.claude/rules/context7.md`).

## Citing Sources in Docs

- When writing a doc of any kind (design docs, specs, READMEs, CLAUDE.md, skills, reports),
  cite the source for every factual claim: a file path, URL, or command output.
- If a claim comes from training data, look it up on the web first and cite the source you
  find. If no source turns up, mark the claim as unverified instead of stating it as fact.

## Tool Calls

- Before taking any action, explore broadly with tool calls.
- After about five tool calls without a message to me, say what you're doing.
- Finish your tool calls first. Write the final answer last.
- Before asking me a question, write the context behind it as a message first, then ask the
  question. Context written between tool calls gets buried and I can't find it.
- Before a complex Bash call that needs my approval, write a short plain-language summary of what
  it does and why as a message first, so I can judge the permission prompt without decoding the
  command.

## Authenticated Services: MCP Fallbacks

For services that need an authenticated login (Jira, Confluence, and other Atlassian tools,
GitHub, Slack, and so on), when the MCP server is down, unauthenticated, or failing:

1. Fall back to an existing, already-authenticated CLI for that service (for example `gh` for
   GitHub, or `acli` for Atlassian if it is installed). Check that it exists with `command -v`
   before relying on it.
2. If no CLI is available, ask me whether to use Claude in Chrome instead. It runs in my real
   browser with my existing sign-ins.

Tell me which fallback you're using and why the MCP path failed.

## Repos and Worktrees

- I clone all my repos into `~/source/`, one directory per repo (for example
  `~/source/arbitrary-repo`).
- Always nest a git worktree inside the repo it was created for, wherever that repo lives:
  under `.claude/worktrees/` if the repo root has a `.claude/` directory, otherwise under
  `.worktrees/`. Make sure the repo's `.gitignore` excludes that directory.
- Never create a worktree as a sibling of the repo or anywhere outside it (for example
  `~/source/arbitrary-repo-feature`).

## Task Skills

Load the matching skill before starting these tasks:

- Committing, pushing, branching, checking CI, or troubleshooting CI (including CircleCI):
  `git-workflow`
- Creating a PR, editing or updating a PR description (including `gh pr edit` mid-task), or
  posting GitHub comments or reviews: `github-prs`
- Drafting, creating, editing, commenting on, or transitioning a Jira ticket: `jira-tickets`

## Jira Tickets for Features

The goal: each ticket becomes one small, focused PR that a human reviewer can read, digest, and
understand in one pass.

- Before drafting a ticket for a feature, read all the code the feature touches and work out
  the full changeset it needs: every file, module, migration, config, test, and doc change.
- If that changeset would make a PR too large to review comfortably, propose splitting it into
  a series of smaller tickets instead of one big ticket. Each ticket covers one coherent set of
  changes, so its PR has a single clear purpose.
- Mark which tickets depend on others and which can be done in parallel, and order them so
  parallel work is easy to pick up.
- Show me the proposed breakdown before creating any tickets.

### Every completed ticket must be owner reviewable

**What owner review is.** Owner Review is a column in our Jira workflow. After a ticket's code
merges and deploys, the ticket moves there. Our product manager, or another teammate, then reviews
the work from a product ownership perspective, not a code perspective: they open the UI (or call
the API or MCP tool), check that the feature was built, and check that it behaves as expected.
They do not read the code or the tests. A ticket whose code is merged, deployed, and tested, but
that nothing a user can reach calls, cannot pass owner review.

So when a ticket's last PR deploys, there must be something the reviewer can run. Individual PRs
within a ticket don't need to be owner reviewable on their own.

- **Build the caller first.** Order tickets outside-in: an early ticket adds the code path a user
  can trigger (endpoint, tool, UI action) that calls the new logic, with that logic stubbed (for
  example a check that always returns "allowed"). Later tickets fill in the real logic, and each
  one changes what a reviewer sees through that code path.
- Never plan a ticket whose new code only tests call once it's done. If logic must come before its
  caller, the same ticket wires in a minimal caller.
- For each ticket, write down how an owner reviewer exercises it after deploy: where to click or
  what to call, and what they should see. If you can't, reorder or regroup the tickets.
- If a feature flag gates the code path, say how the reviewer gets the flag turned on for
  themselves, so the flag doesn't block review.
- **Bake this into every spec and plan file**, whichever skill writes it (brainstorming,
  writing-plans, stack-driven-dev, or by hand). This rule overrides those skills' templates:
  - **Spec:** an "Owner review" section. Open it with a short explanation of what owner review is
    (from the paragraph above), since spec readers may not know our Jira workflow. Then list each
    ticket, the user-facing code path it adds or changes, and what an owner reviewer does and
    sees after it deploys.
  - **Plan:** order the tasks caller-first. Each ticket's last task ends with an "Owner review"
    step (where to click or what to call, expected result, flag setup), and the plan's
    ticket and PR breakdown table has an "Owner review" column.
  - Before calling a spec or plan done, check every ticket against this rule. If a ticket fails,
    reorder or regroup the tickets before writing any code.

Why: in the MCP allowed-schemas work (CIVIS-15103), the SQL checker shipped across three PRs with
nothing calling it, so it merged and deployed but could not be owner reviewed until CIVIS-15092
wired it in.

## Code Review

- Before reviewing a PR, read its Jira ticket to learn what the change is meant to do. Find the
  ticket key in the branch name, PR title, or PR description. If there is no ticket, ask me for
  the intent instead of guessing it from the diff.
- Judge findings against that intent. Flag it when the PR misses part of the ticket or goes
  beyond its scope.
- Group findings into these categories, most important first. Skip empty categories:
  - 🎯 **Blocks the ticket's intent**: bugs or gaps that stop the PR from doing what the ticket asks
  - 🐛 **Other bugs or risks**: real problems not tied to the ticket (security, data loss, regressions)
  - ✨ **Nice to have**: improvements worth making, but not required to merge
  - 🧹 **Nitpicks**: style, naming, small readability tweaks
  - ❓ **Questions**: things I need to clarify with the author before judging

## Verification Before Claiming Success

- Never report a command as successful based on a piped exit code—check it unpiped or via
  `${pipestatus[1]}`. My shell is zsh: the array is lowercase and 1-indexed, and bash's
  `${PIPESTATUS[0]}` silently expands to an empty string here.
- After a rebase, merge, or subagent-delegated git operation, confirm with `git log --oneline -5` before reporting done.
- If challenged ("are you sure?"), re-test empirically rather than restating the original conclusion.

## Output Management (Long Sessions)

Large bash outputs accumulate in context for the entire session. Keep them small:

- Builds/tests: pipe through `| tail -50` or `| head -50`
- Compilations: `| grep -iE "error|warning|failed"`
- When full output matters but is large: redirect to a temp file, read only what's needed
  - `some-command > /tmp/claude-output.txt && tail -30 /tmp/claude-output.txt`
- Never dump full directory listings, full build logs, or full test suite output. Truncate or filter them first
