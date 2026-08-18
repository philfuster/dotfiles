# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Neovim Configuration Overview

This is a LazyVim-based Neovim configuration with custom extensions. The
configuration uses Lua for all settings and plugin management.

### How the documentation divides up

- **This file**: conventions, invariants, and gotchas. The rules to follow and
  the things not to break.
- **[NEOVIM_CONFIG_GUIDE.md](NEOVIM_CONFIG_GUIDE.md)**: feature and plugin
  descriptions, workflows, and keymap discovery. The source of truth for what
  this configuration does.
- **[CEPs/README.md](CEPs/README.md)**: the index of Config Enhancement
  Proposals.

Do not restate the guide's content here. Link to it. Prose duplicated across
these files has silently drifted out of date before.

## Architecture

### Core Structure

- **Entry Point**: `init.lua` bootstraps the configuration by loading
  `lua/config/lazy.lua`
- **Plugin Manager**: Uses lazy.nvim for plugin management with lazy loading
- **Base Framework**: Built on LazyVim with extensive customizations via extras
  system
- **Configuration Pattern**: Plugins are organized as individual Lua modules in
  `lua/plugins/`
  - `extend-*.lua` files modify LazyVim default plugins
  - Other `.lua` files add new plugins or disable defaults

### Key Configuration Files

- `lua/config/options.lua`: Neovim options (updatetime, scrolloff, undo
  settings)
- `lua/config/keymaps.lua`: Custom key mappings beyond LazyVim defaults
- `lua/config/autocmds.lua`: Autocommands (yank highlighting, auto-mkdir,
  quick-close)
- `lazyvim.json`: Declares which LazyVim extras are enabled

### Plugin Architecture Pattern

Plugins follow a consistent return table structure using the standard
"author/repository" format:

```lua
return {
  "author/plugin-name",  -- Always use "author/repository" format for precision
  opts = { -- configuration options },
  keys = { -- keybindings },
  dependencies = { -- required plugins }
}
```

**Plugin Naming Standards:**

- Use full `"author/repository"` format (e.g., `"folke/snacks.nvim"`,
  `"max397574/better-escape.nvim"`)
- Avoid short names like `"snacks.nvim"` to prevent ambiguity
- This ensures precise plugin identification and follows lazy.nvim best
  practices

## Common Development Commands

Commands that cannot be discovered from inside Neovim:

```vim
:Lazy              " Plugin manager UI (also update, sync, clean, profile)
:Mason             " Manage LSP servers, formatters, linters
:LspInfo           " LSP status for the current buffer
:ConformInfo       " Which formatter runs for the current buffer, and why
:Trouble           " Diagnostics panel
:checkhealth       " Verify Neovim and plugin health
```

**Do not add a key binding list to this file.** Every previous copy went stale.
Discover bindings live instead:

- Press `<leader>` and wait for which-key to show the available mappings
- `:map` or `:map <key>` for the current state of a mapping
- Read the `keys` table in the relevant `lua/plugins/*.lua` file

See NEOVIM_CONFIG_GUIDE.md, "Discovering Key Bindings", for the full set of
methods.

## Code Formatting

### Lua Files

- **Formatter**: Stylua (configured in `stylua.toml`)
- **Style**: 2 spaces, max 120 columns
- **Command**: Formatting happens automatically on save or via `<leader>cf`

### Markdown Files

- **Formatter**: Prettier (via conform.nvim)
- **Linter**: markdownlint-cli2 (via Mason)
- **Effective options**: `printWidth: 80` and `proseWrap: always`, from
  `~/.config/.prettierrc`. Prettier locates that file by searching upward from
  the file being formatted, so everything under `~/.config` inherits it. No
  config path is set anywhere in this repository.

### TypeScript/JavaScript

- **Formatters**: Prettier when a Prettier config is found, Biome otherwise
- **LSP**: TypeScript language server configured

## Testing Strategy

There is no test suite for the Neovim configuration itself, and adding one is
not expected. Verify changes by loading them: `:checkhealth`, `:Lazy profile`,
and manual exercise of the affected keybindings. See NEOVIM_CONFIG_GUIDE.md,
"Troubleshooting", for the health check commands.

## Important Implementation Notes

1. **LazyVim Extras System**: Most functionality comes from LazyVim extras
   declared in `lazyvim.json`. Modifying core behavior requires extending or
   overriding these extras.

2. **Plugin Loading**: Plugins are lazy-loaded by default. Dependencies and
   loading conditions are handled by lazy.nvim.

3. **Prettier is conditional**: `vim.g.lazyvim_prettier_needs_config = true`
   (`lua/config/options.lua:6`) means Prettier runs only when a Prettier config
   file is found for the buffer. `lua/plugins/extend-conform.lua` lists
   `{ "prettier", "biome", stop_after_first = true }` per filetype, so Biome is
   the fallback when no config is found. This replaced a hand-rolled detection
   layer (see CEP-005). Do not reintroduce a hardcoded config path.

4. **Neo-tree stays disabled**: `lua/plugins/disabled.lua` disables neo-tree
   because mini-files and the snacks explorer own file navigation. Do not
   re-enable it.

5. **Feature behavior is documented in the guide**: session management,
   performance tuning, and per-plugin behavior live in NEOVIM_CONFIG_GUIDE.md.
   Read it there rather than adding a second copy here.

## Config Enhancement Proposals (CEPs)

The `CEPs/` directory contains Config Enhancement Proposals - structured
documents for planning and tracking configuration changes. This system helps:

- Document configuration experiments and their outcomes
- Track rationale behind decisions
- Plan complex changes systematically
- Learn from both successful and failed attempts

See [CEPs/README.md](CEPs/README.md) for the index of existing proposals, the
status vocabulary, and the full process. Copy `CEPs/template.md` to create a new
one.

## Working with This Configuration

When modifying this configuration:

1. Add new plugins as separate files in `lua/plugins/`
2. Extend existing plugins with `extend-[plugin-name].lua` pattern
3. Test changes with `:Lazy reload` or restart Neovim
4. Check `:messages` and `:Lazy` for errors
5. Update `lazy-lock.json` when stabilizing plugin versions
6. Document new plugins in NEOVIM_CONFIG_GUIDE.md, not in this file
7. Consider creating a CEP for complex or experimental changes
