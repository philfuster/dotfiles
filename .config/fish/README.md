# Fish Shell Configuration

This is the fish setup for, tracked in the bare-repo dotfiles at `~/.cfg/`. Fish
is the primary interactive shell on Linux. The config is organized for two
machines (work and personal) sharing the same dotfiles, with personalization
layered on top via per-machine universal variables.

## Layout

| Path                                 | What lives there                                                                                               |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| `config.fish`                        | Interactive setup: dotfiles wrapper, project shortcuts, SSH keychain helper, env vars, vi-mode + cursor shapes |
| `functions/fish_prompt.fish`         | Custom multi-line prompt (theme-aware)                                                                         |
| `functions/theme.fish`               | Theme switcher (`theme knicks` / `theme work`)                                                                 |
| `functions/fisher.fish`              | [fisher](https://github.com/jorgebucaran/fisher) plugin manager (installed by fisher itself)                   |
| `functions/nvm.fish` + `_nvm_*.fish` | Node Version Manager (from `jorgebucaran/nvm.fish` plugin)                                                     |
| `conf.d/`                            | Auto-loaded snippets — `nvm.fish`, three `tmux.*` files (tmux plugin), `vi_mode_repaint.fish` (vi-mode repaint hook) |
| `completions/`                       | Fish completions for `fisher` and `nvm`                                                                        |
| `fish_plugins`                       | Manifest of fisher-managed plugins                                                                             |
| `fish_variables`                     | Universal variables (syntax colors, fisher state, paths). **Per-machine**, written by `set -U`.                |
| `themes/`                            | Reserved by fish for `fish_config theme save`. Unused here.                                                    |
| `.env`                               | **Gitignored.** Holds `SSH_PRIVATE_KEYS` and `SSH_KEY_PASSPHRASE` for `fish_keychain`.                         |

## What `config.fish` sets up

The body runs only when `status is-interactive` AND `uname` is Linux.

### Functions defined inline

- **`config`** — wraps `git --git-dir=$HOME/.cfg/ --work-tree=$HOME` so you can
  run `config status`, `config add ...`, `config commit ...` against the
  dotfiles bare repo. See `~/.config/DOTFILES_MANAGEMENT.md` for the full
  workflow.
- **`gtw`** — `pushd ~/code/projects/storis/nextgen/`. Quick jump into the
  NextGen working tree.
- **`:ngcd`** — clean-installs NextGen deps:
  `pnpm install && pnpm dedupe && pnpm install` from the nextgen dir.
- **`:ngpnpm`** — runs `pnpm <args>` against NextGen using the nvm-pinned Node
  version (currently hardcoded path to `~/.local/share/nvm/v22.14.0/bin/pnpm`).
- **`fish_keychain`** — unlocks SSH keys non-interactively. Reads
  `SSH_PRIVATE_KEYS` and `SSH_KEY_PASSPHRASE` from `~/.config/fish/.env`, then
  drives `keychain` via `expect` to feed the passphrase. Requires the `expect`
  and `keychain` apt packages and a populated `.env` file.

### Environment

- `PNPM_HOME=/home/paf/.local/share/pnpm/` and prepended to `$PATH`.
- `fish_user_paths` adds `~/.local/bin`, `/opt/nvim-linux-x86_64/bin`, and
  `/usr/local/go/bin`.
- `fish_greeting` cleared (no banner on shell start).

### Editing

- `fish_key_bindings = fish_vi_key_bindings` — modal editing.
- Per-mode cursor shapes:
  - `default` (normal) → block
  - `insert` → line
  - `replace_one` → underscore
  - `replace` → underscore
  - `visual` → block
- Inside tmux, `fish_vi_force_cursor=1` so the cursor shape changes actually
  propagate.

## Plugins

Managed by [fisher](https://github.com/jorgebucaran/fisher). The manifest is
`fish_plugins`:

| Plugin                  | Purpose                                               |
| ----------------------- | ----------------------------------------------------- |
| `jorgebucaran/fisher`   | The plugin manager itself                             |
| `jorgebucaran/nvm.fish` | Node version manager — `nvm use`, `nvm install`, etc. |
| `budimanjojo/tmux.fish` | tmux helpers; auto-attaches and provides `tm` etc.    |

Common operations:

```fish
fisher install <repo>     # add a plugin (also updates fish_plugins)
fisher remove <repo>      # uninstall
fisher update             # update all
fisher list               # what's installed
```

After modifying `fish_plugins` directly, run `fisher update` to sync.

## Prompt

`functions/fish_prompt.fish` is a custom multi-line prompt forked from "nim". A
typical render:

```
┬─[paf@PROMETHEUS:~/code/storis/nextgen]─[14:23:07]─[N]─[G:main↑1|●1✚1]
╰─>$
```

Layout:

```
┬─[user@host:path]─[time]─[mode]─[V:venv]─[G:git]─[B:battery]
│ <background job line, if any>
╰─>$
```

Segments are conditional — only `user@host:path`, time, and the mode indicator
always render. Venv, git, and battery only appear when relevant.

**Frame color** tracks the previous command's exit status: green/blue (success)
or red (failure). This is the `┬`, `─`, `│`, `╰─>` glyphs.

**Vi mode** is shown as a single inline letter — `N`/`I`/`R`/`V`, themed per
mode — inside the prompt's bracket structure. The stock left-side
`fish_mode_prompt` is suppressed (`functions/fish_mode_prompt.fish` is
intentionally empty) so we don't get a double indicator: Warp hides the stock
one via its block UI, but tmux passes raw fish output through and would
otherwise surface it. To keep the inline indicator reactive on `<Esc>`,
`conf.d/vi_mode_repaint.fish` listens on `fish_bind_mode` and forces a
`repaint` — fish only redraws `fish_mode_prompt` on a mode change by default,
not the whole prompt.

## Themes

The prompt and the syntax-highlighting palette are themeable as a unit. Two
themes ship today:

- **`work`** (default, Dracula) — the original look. Cyan commands, yellow
  strings, purple params, green frame on success.
- **`knicks`** — New York Knicks colors. Blue `#1E90FF`, Orange `#F58426`,
  Silver `#BEC0C2`, with red kept for true errors.

### Switching

```fish
theme knicks      # activate Knicks
theme work        # activate default (also accepts: default, dracula)
theme             # show current (no arg)
exec fish         # refresh the running shell so the prompt frame and syntax colors both update
```

Universal vars (`set -U`) take effect immediately for new shells, but the
current shell has already rendered its prompt — `exec fish` re-launches in
place.

### Where the colors live

Two layers, controlled separately:

1. **Prompt elements** — set inside `fish_prompt` based on `$nim_theme`. These
   are the colors of the frame, brackets, username, hostname, path, vi-mode
   indicator, `$ ` leader, etc.
2. **Syntax highlighting** — fish's built-in `fish_color_*` and
   `fish_pager_color_*` universal variables. Used for what you type (commands,
   params, quotes, errors), the autosuggestion ghost text, and the completion
   pager.

`theme.fish` updates both layers in lockstep.

### Prompt-element palette

| Element               | Default (Dracula) | Knicks         |
| --------------------- | ----------------- | -------------- |
| Frame on success      | `green`           | `#1E90FF`      |
| Frame on failure      | `red`             | `red`          |
| Brackets `[ ]`        | bold `green`      | bold `#BEC0C2` |
| Username (you)        | bold `yellow`     | bold `#F58426` |
| Username (root)       | bold `red`        | bold `red`     |
| `@` separator         | bold `white`      | bold `#BEC0C2` |
| Hostname (local)      | bold `blue`       | bold `#1E90FF` |
| Hostname (SSH)        | bold `cyan`       | bold `cyan`    |
| Path                  | bold `white`      | bold `#BEC0C2` |
| Vi mode `N` (normal)  | `red`             | `red`          |
| Vi mode `I` (insert)  | `green`           | `#1E90FF`      |
| Vi mode `R` (replace) | `cyan`            | `cyan`         |
| Vi mode `V` (visual)  | `magenta`         | `#F58426`      |
| Background job text   | `brown`           | `#F58426`      |
| `$ ` input leader     | bold `red`        | bold `#F58426` |

### Syntax-highlighting palette

| `fish_color_*`    | Default (Dracula)     | Knicks                |
| ----------------- | --------------------- | --------------------- |
| `command`         | `8be9fd`              | `1E90FF`              |
| `keyword`         | unset                 | `1E90FF`              |
| `param`           | `bd93f9`              | `BEC0C2`              |
| `quote`           | `f1fa8c`              | `F58426`              |
| `redirection`     | `f8f8f2`              | `F58426`              |
| `operator`        | `50fa7b`              | `F58426`              |
| `error`           | `ff5555`              | `ff5555`              |
| `escape`          | `ff79c6`              | `F58426`              |
| `comment`         | `6272a4`              | `7a7d80`              |
| `autosuggestion`  | `6272a4`              | `4a4d50`              |
| `normal`          | `f8f8f2`              | `BEC0C2`              |
| `user`            | `8be9fd`              | `F58426`              |
| `host`            | `bd93f9`              | `1E90FF`              |
| `host_remote`     | unset                 | `cyan`                |
| `cwd`             | `50fa7b`              | `BEC0C2`              |
| `cwd_root`        | `red`                 | `red`                 |
| `end`             | `ffb86c`              | `F58426`              |
| `status`          | `red`                 | `red`                 |
| `cancel`          | `ff5555 --reverse`    | `ff5555 --reverse`    |
| `match`           | `--background=brblue` | `--background=1E90FF` |
| `search_match`    | `--background=44475a` | `--background=003a66` |
| `selection`       | `--background=44475a` | `--background=003a66` |
| `valid_path`      | `--underline`         | `--underline`         |
| `history_current` | `--bold`              | `--bold`              |

Pager colors (`fish_pager_color_*`) follow the same logic — see `theme.fish` for
the full list.

### How it works

- **`$nim_theme`** is a universal variable. When set to `knicks`, the palette
  block at the top of `fish_prompt` picks the Knicks color names; otherwise it
  picks the Dracula palette.
- **`set` (no flag)** is used inside the palette `if/else`, not `set -l`.
  `set -l` would scope the variable to the `if` block only — every `c_*` would
  be empty by the time the rest of the prompt ran. Bare `set` makes them
  function-scoped.
- **`last_status`** is captured as the very first line of `fish_prompt`. The
  palette `test` (`test "$nim_theme" = knicks`) overwrites `$status`, so without
  this capture, the frame would always look like the previous command failed.
- **`_nim_prompt_wrapper`** (the helper that renders each `─[label:value]`
  segment) takes the bracket color as its 4th argument. Nested fish functions
  don't inherit locals from the enclosing function, so the color has to be
  passed explicitly.
- **`set -U` is per-machine.** `fish_variables` lives next to your config but
  isn't replicated through the dotfiles repo the same way checked-in files are.
  Running `theme knicks` on the personal box doesn't change anything on work,
  even though the function definition is shared.

### Adding a new theme

Say you want a `tokyo-night` theme:

1. **Add a palette branch** in `functions/fish_prompt.fish`. Inside the
   `if test "$nim_theme" = ...` block, add:

   ```fish
   else if test "$nim_theme" = tokyo-night
       set c_ok 7aa2f7
       set c_fail f7768e
       set c_bracket c0caf5
       # ... fill in the rest of the c_* vars
   ```

2. **Add a `case` arm** in `functions/theme.fish` that sets every `fish_color_*`
   and `fish_pager_color_*` universal var for the new theme.

3. **Activate**: `theme tokyo-night && exec fish`.

The full list of slots to fill: `c_ok`, `c_fail`, `c_bracket`, `c_user`,
`c_user_root`, `c_at`, `c_host_local`, `c_host_ssh`, `c_path`, `c_mode_n`,
`c_mode_i`, `c_mode_r1`, `c_mode_r`, `c_mode_v`, `c_jobs`, `c_dollar`.

## Cross-machine notes

- The whole `~/.config/fish/` tree (except `fish_variables` and `.env`) ships
  through the bare repo at `~/.cfg/`. Edit anywhere,
  `config commit && config push`, then `config pull` on the other machine.
- `fish_variables` is local to each machine. Don't track it — universal vars are
  the right place for "this machine prefers Knicks" and similar choices.
- `.env` is gitignored. Each machine needs its own copy if you want
  `fish_keychain` to work.
- New machine: clone the bare repo (see `~/.config/DOTFILES_MANAGEMENT.md`),
  `fisher update` to install plugins, optionally `theme knicks` if it's the
  personal box.

## Troubleshooting

**`set_color: Unknown color ''`** — historically caused by `set -l` inside the
prompt's palette `if/else` (block-scoped, so palette vars vanished after the
branch). Fixed by using bare `set`. Don't reintroduce `-l` in the palette block.

**Prompt frame stuck on red after switching themes** — the
`last_status = $status` capture is missing or moved. It must be the first
non-comment line in `fish_prompt`, before anything else (including the palette
branch) runs `test`/`set`.

**Syntax colors didn't update after `theme <name>`** — the universal vars are
set, but your current shell already rendered. Run `exec fish` (replaces the
running shell with a new one in place) or open a new pane.

**Knicks accidentally on work machine** — `theme work` then `exec fish`.
Universal vars are local; nothing was pushed to the dotfiles repo.

**`fish_keychain` errors about `.env`** — create `~/.config/fish/.env` with:

```
set -gx SSH_PRIVATE_KEYS ~/.ssh/id_ed25519
set -gx SSH_KEY_PASSPHRASE <your-passphrase>
```

…and install the deps: `sudo apt install expect keychain`.

**Prompt characters look like boxes/squares** — your terminal font lacks the
box-drawing glyphs (`┬`, `─`, `│`, `╰`). Switch to a Nerd Font or any font with
full box-drawing coverage (Cascadia Code, MesloLGS NF, JetBrains Mono).

**Two vi-mode indicators inside tmux** — the stock `fish_mode_prompt` is leaking
through. Make sure `~/.config/fish/functions/fish_mode_prompt.fish` exists and
is an empty function; without it, fish falls back to `fish_default_mode_prompt`
and Warp's block-UI hiding only applies outside tmux. Pair it with the
`--on-variable fish_bind_mode` repaint handler in
`conf.d/vi_mode_repaint.fish` so the inline indicator updates on `<Esc>`.

## See also

- `~/.config/DOTFILES_MANAGEMENT.md` — bare-repo dotfiles workflow
- `~/.config/CLAUDE.md` — guidance for Claude Code on the dotfiles repo
- [fish docs](https://fishshell.com/docs/current/index.html)
- [fisher](https://github.com/jorgebucaran/fisher)
- [nvm.fish](https://github.com/jorgebucaran/nvm.fish)
