<!-- TRELLIS:START -->
# Trellis Instructions

These instructions are for AI assistants working in this project.

This project is managed by Trellis. The working knowledge you need lives under `.trellis/`:

- `.trellis/workflow.md` — development phases, when to create tasks, skill routing
- `.trellis/spec/` — package- and layer-scoped coding guidelines (read before writing code in a given layer)
- `.trellis/workspace/` — per-developer journals and session traces
- `.trellis/tasks/` — active and archived tasks (PRDs, research, jsonl context)

If a Trellis command is available on your platform (e.g. `/trellis:finish-work`, `/trellis:continue`), prefer it over manual steps. Not every platform exposes every command.

If you're using Codex or another agent-capable tool, additional project-scoped helpers may live in:
- `.agents/skills/` — reusable Trellis skills
- `.codex/agents/` — optional custom subagents

Managed by Trellis. Edits outside this block are preserved; edits inside may be overwritten by a future `trellis update`.

<!-- TRELLIS:END -->

# OhMySkills Repository Rules

These rules are specific to this repository. General AI behavior rules live in `skills/oms-*`.

## Source of truth

- `skills/<skill-name>/SKILL.md` is the source of truth for each skill.
- `README.md` explains installation, usage, supported agents, and shipped skills; do not duplicate long rule bodies there.
- `templates/` contains reusable examples only. Use placeholders for local URLs, accounts, passwords, tokens, and internal paths.

## Skill maintenance

When adding, changing, or removing a skill, also check:

- `README.md` skill table, trigger examples, install/uninstall examples, and Roadmap.
- Frontmatter `name` matches the skill directory name.
- The rule belongs in the right layer:
  - `oms-meta`: highest-priority cross-task meta rules.
  - `oms-qa`: conversation and questioning style.
  - `oms-coding`: general coding execution discipline.
  - `oms-be-coding` / `oms-fe-coding`: backend/frontend domain differences.
  - `oms-review`: review of diffs, PRs, code, and designs.
- Shared rules appear in one best source only; other skills should reference `$oms-X` instead of copying. In a skill body, `$oms-X` is a cross-skill pointer meaning "see the oms-X skill", not copied rule text.

## Content boundaries

- Skills should contain rules that change agent behavior, not marketing copy or long tutorials.
- General rules must work for legacy projects; do not require breaking existing APIs, UI, directories, or workflows by default.
- Project-specific rules belong in the consuming project’s own `AGENTS.md` / `CLAUDE.md` / `now.md`, not in universal skills.
- Before release, verify there are no real credentials, internal URLs, customer data, stale skill counts, or outdated Roadmap entries.
