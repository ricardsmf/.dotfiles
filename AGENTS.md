# DOTFILES

**Generated:** 2026-05-09T00:00:00Z
**Commit:** 871ce6f

macOS dev env via nix-darwin + home-manager. Fish + Neovim + Tmux + Git + pi.

Packages: CLI tools are native nixpkgs (`environment.systemPackages`); GUI casks +
custom-tap brews are managed by nix-darwin's `homebrew` module. Nix is Lix, installed via
the Lix installer and pinned by nix-darwin (`nix.package = pkgs.lixPackageSets.stable.lix`).
`dot` orchestrates
`darwin-rebuild switch`; home-manager owns the dotfile symlinks (`nix/home.nix`).

## STRUCTURE

```
.dotfiles/
├── dot                 # CLI: init/update/doctor/package (2500 lines bash)
├── home/.config/       # Symlinked to ~/.config/ by home-manager
│   ├── fish/           # Shell (AGENTS.md)
│   ├── nvim/           # Editor (AGENTS.md)
│   ├── tmux/           # Multiplexer (TPM plugins live in ~/.local/share/tmux)
│   ├── git/            # Conditional work config
│   ├── kitty/          # Terminal (+ kitty-scrollback.nvim)
│   ├── yazi/           # File manager
│   ├── hunk/           # Diff viewer (modem-dev/tap)
│   ├── karabiner/      # Hyper key (Caps Lock -> ctrl+opt+cmd+shift)
│   ├── starship.toml   # Prompt (custom.scm, 2s timeout for Vite+)
│   └── ripgrep/        # rg config
├── home/.pi/agent/     # Pi: settings.json + global AGENTS.md (rest is gitignored)
├── home/.claude/       # Claude Code: settings.json, CLAUDE.md, npm workspace
│   └── skills/         # 32 Agent Skills — shared with pi, single source of truth
├── flake.nix           # nix-darwin flake; darwinConfigurations."PT-RICARDOFERREIRA"
├── nix/
│   ├── darwin.nix      # system module (imports + nixpkgs config + primaryUser)
│   ├── packages.nix    # CLI tools → environment.systemPackages (nixpkgs)
│   ├── homebrew.nix    # casks + custom-tap brews (homebrew module)
│   └── home.nix        # home-manager: symlinks home/ into ~
└── docs/
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| Add CLI tool | `dot package add <nixpkgs-attr>` or edit `nix/packages.nix` |
| Add GUI app/cask | `dot package add <cask> cask` or edit `nix/homebrew.nix` |
| Shell alias/abbr | `home/.config/fish/conf.d/aliases.fish` |
| Shell function | `home/.config/fish/functions/` |
| Git alias | `home/.config/git/config` [alias] section |
| Neovim plugin | `home/.config/nvim/lua/plugins/<name>.lua` |
| Neovim keymap | `home/.config/nvim/lua/ricardsmf/keymaps.lua` |
| Tmux binding | `home/.config/tmux/tmux.conf` |
| Hyper key / key remap | `home/.config/karabiner/karabiner.json` |
| Starship prompt | `home/.config/starship.toml` |
| Agent skill (pi + Claude) | `home/.claude/skills/<name>/SKILL.md` |
| Pi settings | `home/.pi/agent/settings.json` |
| Pi global instructions | `home/.pi/agent/AGENTS.md` |
| Claude settings | `home/.claude/settings.json` |
| Work git identity | Auto via `home/.config/git/work_config` for `~/Code/work/` |

## CONVENTIONS

- Link layout: `home/` mirrors `~`; `nix/home.nix` reads that tree and links each entry
  with `mkOutOfStoreSymlink`, so the symlinks point at the **live repo**, not the store.
  Editing through `~/.config/<app>` edits the repo file. A *new* top-level entry needs a
  `darwin-rebuild switch` before it is linked; edits to existing files need nothing.
- Fish: `conf.d/` auto-sourced, `functions/` lazy-loaded
- Neovim: 1 plugin per file in `lua/plugins/`, returns lazy.nvim spec
- Git abbrs: ~180 oh-my-zsh style via `__git.init.fish`
- Private helpers: prefix `__` (e.g., `__git.default_branch`)
- Agent skills: Markdown-first, Agent Skills standard (`SKILL.md` + `name`/`description` frontmatter)
- Skills live once in `home/.claude/skills/`; pi loads that same dir via `skills` in its `settings.json` — never duplicate them
- `disable-model-invocation: true` hides a skill from the system prompt; invoke it with `/skill:<name>`

## ANTI-PATTERNS

- `dot package add brew X` expecting the brew name — `pkg` adds the **nixpkgs attr** (e.g. `awscli2`, `ripgrep`)
- Assuming cask removal is safe — `onActivation.cleanup = "zap"`, so undeclared casks/brews are uninstalled **and zapped** on switch
- Hardcode paths (use `$DOTFILES_DIR`, `$HOME`)
- Nested git repos in linked dirs (creates symlink issues)
- Symlinking `karabiner.json` as a *file* — Karabiner-Elements rewrites it atomically and
  would replace the symlink with a real file. `nix/home.nix` links the whole `karabiner/`
  dir instead, which keeps it writable; never link the file individually.
- node_modules in linked dirs (`home/.claude` is an npm workspace over `skills/*` — gitignored there)

## COMMANDS

```bash
dot init              # Full setup (brew, nix, darwin-rebuild, bun, ssh, font, fish)
dot update            # Pull + nix flake update + darwin-rebuild switch + pi update + Pocock skills sync
dot doctor            # Health check (checks brew, nix-darwin, fish)
dot package add X [pkg|cask]  # Edit nix config + darwin-rebuild switch (pkg = nixpkgs attr, default)
dot benchmark-shell   # Fish startup perf
dot gen-ssh-key       # Generate ed25519 key by email domain
```

## KEY CONFIGS

| Tool | Entry | Notes |
|------|-------|-------|
| Fish | `config.fish` | Sources `conf.d/`, sets EDITOR/MANPAGER |
| Neovim | `init.lua` | 1 line: `require("ricardsmf")` |
| Tmux | `tmux.conf` | Prefix `C-a`, auto-installs TPM to `~/.local/share/tmux/plugins` |
| Kitty | `kitty.conf` | Terminal; `cmd+s` scrollback in nvim |
| Git | `config` | SSH signing, `pull.rebase`, conditional include |
| Starship | `starship.toml` | 2s timeout (Vite+ shims), custom.scm after dir |
| Karabiner | `karabiner.json` | Caps Lock -> Hyper; `~/.config/karabiner` is a **dir** symlink |
| Pi | `settings.json` | anthropic/claude-opus-5, thinking `high`, skills from `~/.claude/skills` |
| Claude Code | `settings.json` + `CLAUDE.md` | 32 skills under `skills/`; npm workspace |

## UNIQUE STYLES

- tmux prefix: `C-a` (not `C-b`); PT keyboard — `C-;` is really `C-S-,`, and `C-Space` collides with macOS input-source switching. `C-a` twice sends a literal `C-a`
- tmux splits: `\` horizontal, `Enter` vertical
- tmux extended-keys: `always` + CSI-u (required for pi/claude-code; fish 4.x parses CSI-u natively, so no shell-side workaround is needed)
- tmux plugins install to `~/.local/share/tmux/plugins`, never into the linked `tmux/` dir (avoids nested git repos)
- tmux/nvim seamless nav: `vim-tmux-navigator` (tmux) + `nvim-tmux-navigation` (nvim), driven by `keymaps.lua` `<C-h/j/k/l>`
- catppuccin tmux v2 uses `@catppuccin_flavor` (no "u"); the v1 `@catppuccin_flavour` is silently ignored
- nvim: `jj`/`JJ` exit insert, `H`/`L` line start/end
- nvim completion: blink.cmp (not nvim-cmp), LSP source score_offset=1000
- git: `fomo` = fetch origin main + rebase
- Hyper key is Karabiner's job, not Raycast's — Raycast's built-in Hyper Key is off
  (`raycast_hyperKey_state.enabled = false`). Raycast command hotkeys still bind to
  ⌃⌥⌘⇧ and keep working.
- Theme: Catppuccin Macchiato across all tools

## NOTES

- `dot update` handles WARP VPN brew API issues automatically (still relevant for cask downloads)
- `home/.config/fish/conf.d/0-nix.fish` prepends the nix bin dir early so prompt-init conf.d files (starship/zoxide) find nix tools
- Tmux theme must load BEFORE continuum (status-right conflict)
- Starship `command_timeout = 2000` because Vite+ node shims are slow
- `secrets.fish` is gitignored — contains env tokens for work services
- `home/.pi/agent/*` is deny-all in `.gitignore` (`auth.json`, `models-store.json`, `sessions/`, `npm/` are secrets/runtime); only `settings.json` + `AGENTS.md` are un-ignored, and the negations must stay last in that block
- pi and Claude Code share skills: both implement the Agent Skills standard, so pi points at `~/.claude/skills` instead of keeping copies
- pi's global instructions are `~/.pi/agent/AGENTS.md`; the global `~/.claude/CLAUDE.md` is Claude-only (pi auto-discovers CLAUDE.md per-project, not the global one)
- jj was removed; repo now uses git only
