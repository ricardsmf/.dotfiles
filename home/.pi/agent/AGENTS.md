# GLOBAL AGENT INSTRUCTIONS

Global instructions for pi, applied in every project.
Project-level `AGENTS.md` / `CLAUDE.md` take precedence over this file.

## CONVENTIONS

- TypeScript preferred over JavaScript for new files
- ESM-first; avoid CommonJS unless the project requires it
- No comments unless the WHY is non-obvious
- Prefer editing existing files over creating new ones
- No summary paragraphs at the end of responses

## ANTI-PATTERNS

- Never commit secrets, tokens, or API keys
- Never amend commits that have already been pushed
- Never use `--no-verify` unless explicitly requested
- Never add features or abstractions beyond what the task requires
- Never run destructive git operations without explicit confirmation

## SKILLS

Skills are shared with Claude Code, loaded from `~/.claude/skills/`
via the `skills` array in `~/.pi/agent/settings.json`. They follow the
Agent Skills standard (`SKILL.md` + `name`/`description` frontmatter),
so a single copy serves both harnesses — do not duplicate them here.

Invoke one explicitly with `/skill:<name>`.
