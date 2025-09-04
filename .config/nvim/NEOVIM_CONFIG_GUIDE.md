# 🚀 Neovim Configuration Guide

This document provides a comprehensive overview of this Neovim configuration, which is built on top of [LazyVim](https://github.com/LazyVim/LazyVim) with custom extensions and modifications.

## 📁 Configuration Structure

```text
~/.config/nvim/
├── init.lua                    # Entry point - bootstraps lazy.nvim
├── lazy-lock.json             # Plugin version lockfile
├── lazyvim.json              # LazyVim configuration and extras
├── stylua.toml               # Lua code formatting configuration
├── lua/
│   ├── config/               # Core configuration
│   │   ├── autocmds.lua     # Auto commands
│   │   ├── keymaps.lua      # Key mappings
│   │   ├── lazy.lua         # Lazy.nvim plugin manager setup
│   │   └── options.lua      # Vim options and settings
│   └── plugins/             # Plugin configurations
│       ├── disabled.lua     # Disabled default plugins
│       ├── extend-*.lua     # Extended LazyVim plugin configs
│       ├── extend-conform.lua # Custom conform.nvim formatter config (e.g., Prettier config path)
│       └── [custom plugins] # Additional plugin configurations
## 📝 Markdown Formatting & Linting

This configuration uses **Prettier** (via Mason and conform.nvim) for formatting markdown files. The setup ensures:

- Prettier is installed and managed by Mason (`:Mason` in Neovim).
- A Prettier config file (e.g., `~/.config/prettierrc` or `.prettierrc.yaml`) is used to control formatting options, such as line length and prose wrapping. Example YAML config:

  ```yaml
  overrides:
    - files: "*.md"
      options:
        printWidth: 80
        proseWrap: always
  ```

- The file `lua/plugins/extend-conform.lua` ensures Prettier always uses your config file by adding:

  ```lua
  return {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        prettier = {
          prepend_args = { "--config", vim.fn.expand("~/.config/prettierrc.yaml") },
        },
      },
    },
  }
  ```

- Markdown linting is provided by `markdownlint-cli2`, also managed by Mason. Diagnostics appear as virtual text or in the diagnostics panel.

**Troubleshooting:**

- If formatting does not wrap lines, ensure your Prettier config is valid YAML or JSON and matches the file extension.
- If Prettier is unavailable, check Mason install, PATH, and that `vim.g.lazyvim_prettier_needs_config` is set appropriately.

**Key commands:**

- Format: `<leader>cf` or `:lua require("conform").format()`
- Lint: Diagnostics appear automatically; use `:Trouble` or `:lua vim.diagnostic.open_float()` to view.

## 🛠 Base Configuration (LazyVim)

This configuration is built on **LazyVim**, a modern Neovim configuration template that provides:

- 🔌 **Plugin Management**: Uses lazy.nvim for fast, lazy-loaded plugins
- 🎨 **Modern UI**: Beautiful, consistent interface with sensible defaults
- ⚡ **Performance**: Optimized startup time and runtime performance
- 🧩 **Modular**: Easy to extend and customize

### Enabled LazyVim Extras

The following LazyVim extras are enabled (see `lazyvim.json`):

#### AI & Coding Assistance

- `lazyvim.plugins.extras.ai.copilot` - GitHub Copilot integration
- `lazyvim.plugins.extras.ai.copilot-chat` - Interactive AI chat
- `lazyvim.plugins.extras.coding.mini-surround` - Text surrounding operations
- `lazyvim.plugins.extras.coding.yanky` - Enhanced yank/paste functionality

#### Development & Debugging

- `lazyvim.plugins.extras.dap.core` - Debug Adapter Protocol support
- `lazyvim.plugins.extras.test.core` - Testing framework integration

#### Editor Enhancements

- `lazyvim.plugins.extras.editor.dial` - Enhanced increment/decrement
- `lazyvim.plugins.extras.editor.inc-rename` - Incremental rename
- `lazyvim.plugins.extras.editor.mini-files` - File explorer
- `lazyvim.plugins.extras.editor.snacks_explorer` - Enhanced file navigation
- `lazyvim.plugins.extras.editor.snacks_picker` - Fuzzy finder enhancements

#### Language Support

- `lazyvim.plugins.extras.lang.git` - Git integration
- `lazyvim.plugins.extras.lang.json` - JSON language support
- `lazyvim.plugins.extras.lang.markdown` - Markdown support
- `lazyvim.plugins.extras.lang.typescript` - TypeScript/JavaScript support

#### Code Formatting

- `lazyvim.plugins.extras.formatting.biome` - Biome formatter
- `lazyvim.plugins.extras.formatting.prettier` - Prettier formatter

#### UI & Visual Enhancements

- `lazyvim.plugins.extras.ui.treesitter-context` - Show code context
- `lazyvim.plugins.extras.util.mini-hipatterns` - Highlight patterns

#### Utilities

- `lazyvim.plugins.extras.util.dot` - Dotfile management support

## ⚙️ Core Configuration

### Options (`lua/config/options.lua`)

Enhanced Neovim settings for better performance and user experience:

**Key Improvements:**

- **Performance**: Faster completion (200ms) and which-key popup (500ms)
- **Navigation**: Keep cursor centered with scroll offset (8 lines)
- **Search**: Smart case-sensitive searching
- **Undo**: Persistent undo across sessions with 10,000 levels
- **Splits**: Open new splits to the right and below
- **Prettier Integration**: Only runs when config file is present

### Keymaps (`lua/config/keymaps.lua`)

Enhanced key mappings for improved workflow:

**Key Features:**

- **Quick Escape**: Multiple escape sequences from insert mode
- **Visual Mode Enhancements**: Keep selection while indenting, move text blocks
- **Centered Navigation**: Page scrolling and search results stay centered
- **Quick Actions**: Fast save, clear search highlighting
- **Better Defaults**: Improved indenting and text movement

*See the actual file for specific key bindings and implementation details.*

### Auto Commands (`lua/config/autocmds.lua`)

Intelligent automation for better user experience:

**Features:**

- **Visual Feedback**: Highlight yanked text for better copy/paste awareness
- **Smart File Handling**: Auto-create parent directories when saving files
- **Quick Navigation**: Press `q` to close help, quickfix, and other special buffers

*Implementation details available in the configuration file.*

## 🔌 Custom Plugins

### Window & Navigation Management

#### Smart Splits (`smart-splits.lua`)

Enhanced window navigation with smart terminal multiplexer integration.

**Purpose**: Seamless window navigation using Alt+hjkl, with intelligent detection of terminal multiplexers like tmux.

#### nvim-spider (`nvim-spider.lua`)

Smarter word motion that skips punctuation.

**Purpose**: Enhanced w/e/b motions that intelligently handle punctuation and programming constructs.

### Text Manipulation

#### Rip Substitute (`rip-substitute.lua`)

Fast, interactive search and replace with live preview.

**Purpose**: Modern search/replace interface with visual feedback (triggered with `g/`).

#### Text Case (`text-case.lua`)

Enhanced text case conversion with Telescope integration.

**Purpose**: Convert text between camelCase, snake_case, UPPER_CASE, etc. with interactive picker (`ga.`).

#### Better Escape (`better-escape.lua`)

Enhanced escape sequences for smoother editing.

**Purpose**: Multiple escape options (jj, jk) with optimized timing to reduce conflicts.

### Enhanced User Experience

#### Todo Comments (`todo-comments.lua`)

Highlight and navigate TODO comments with style.

**Purpose**: Beautiful highlighting of TODO, FIXME, HACK, etc. with navigation (`]t`/`[t`) and search integration.

#### Better Quickfix (`nvim-bqf.lua`)

Enhanced quickfix window experience with better navigation and preview.

**Purpose**: Improved quickfix list with preview capabilities and better interaction.

### Git Integration

#### Git Conflict (`git-conflict.lua`)

Enhanced git conflict resolution with visual indicators and quick actions.

**Purpose**: Streamlined conflict resolution with clear visual markers and shortcuts for choosing changes. Navigate between conflicts and manage resolution efficiently.

### Development Tools

#### Guess Indent (`guess-indent.lua`)

Automatically detects and sets indentation based on file content.

**Purpose**: Smart indentation detection that overrides editorconfig when needed.

#### TS Comments (`ts-comments.lua`)

Enhanced commenting with TreeSitter integration for better language support.

#### Mini Files Navigation (`extend-mini-files.lua`)

Enhanced mini-files explorer with convenient access to different directory contexts.

**Purpose**: Quick file navigation with shortcuts for current file directory, working directory, and project root.

#### Session Management (`extend-snacks.lua`)

Enhanced dashboard with session management integration.

**Purpose**: Quick access to previous sessions directly from the dashboard for faster project switching.

### Extended LazyVim Plugins

The configuration extends several LazyVim plugins with custom settings:

- **`extend-bufferline.lua`** - Enhanced buffer line customization
- **`extend-gitsigns.lua`** - Extended git signs functionality
- **`extend-mini-surround.lua`** - Surround text object extensions
- **`extend-neotest.lua`** - Testing framework customizations
- **`extend-nvim-dap.lua`** - Debug adapter protocol extensions
- **`extend-nvim-lspconfig.lua`** - LSP configuration extensions

### Disabled Plugins

#### Neo-tree (`disabled.lua`)

Neo-tree file explorer is disabled in favor of mini-files and snacks explorer.

## 🎯 Key Features & Workflows

### Discovering Key Bindings

Rather than duplicating all key bindings in this guide, use these methods to discover them:

**In Neovim:**

- Press `<leader>` and wait → WhichKey shows available leader mappings
- Type `:map` → Show all current mappings
- Type `:map <key>` → Show mappings for a specific key
- Use `:Telescope keymaps` → Search through all key mappings

**In Configuration Files:**

- Check `lua/config/keymaps.lua` for core mappings
- Each plugin file documents its specific key bindings
- Plugin descriptions include their primary triggers

### Development Workflow

1. **File Navigation**
   - Fuzzy finding with Telescope
   - Tree-style navigation with mini-files (current, working, root directories)
   - Smart window navigation with Alt+hjkl

2. **Code Editing**
   - Enhanced escape sequences and quick save
   - Smart word motions and text manipulation
   - AI-assisted coding with GitHub Copilot
   - Interactive case conversion and search/replace

3. **Git Integration**
   - Visual git signs and blame information
   - Streamlined conflict resolution with visual indicators
   - Comprehensive git operations through LazyVim

4. **Search & Development**
   - Interactive search/replace with live preview
   - Auto-centered search results and navigation
   - Todo management with highlighting and navigation
   - Enhanced quickfix and debugging workflows

5. **Quality of Life**
   - Visual feedback for copy operations
   - Automatic directory creation
   - Quick close for helper windows
   - Session management for project switching

### AI-Assisted Development

- **GitHub Copilot**: Inline code suggestions
- **Copilot Chat**: Interactive AI assistance for code questions and refactoring

### Supported Languages

Pre-configured support for:

- **TypeScript/JavaScript** - Full LSP, formatting, and testing
- **JSON** - Schema validation and formatting
- **Markdown** - Preview, TOC, and formatting
- **Git** - Commit messages, file history
- **Lua** - Neovim configuration development

## 🔧 Customization

### Adding New Plugins

1. Create a new file in `lua/plugins/`
2. Follow the lazy.nvim plugin specification
3. Use the existing plugins as templates

Example:

```lua
-- lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  opts = {
    -- configuration
  },
  keys = {
    { "<leader>x", "<cmd>PluginCommand<cr>", desc = "Description" }
  }
}
```

### Extending Existing Plugins

Create `extend-[plugin-name].lua` files to modify LazyVim defaults:

```lua
-- lua/plugins/extend-plugin.lua
return {
  {
    "plugin/name",
    opts = {
      -- your custom options
    }
  }
}
```

### Adding Custom Keymaps

Add to `lua/config/keymaps.lua`:

```lua
vim.keymap.set("n", "<leader>custom", function()
  -- your custom function
end, { desc = "Custom action" })
```

## 📊 Performance & Optimization

- **Lazy Loading**: Plugins load only when needed
- **Smart Defaults**: Optimized settings for modern development
- **Fast Startup**: Typically < 50ms startup time
- **Memory Efficient**: Minimal RAM usage compared to full IDE
- **Enhanced Caching**: Enabled lazy.nvim cache for faster subsequent loads
- **Disabled Plugins**: Removed unnecessary default plugins (gzip, tar, zip, etc.)
- **Optimized Timeouts**: Faster completion (200ms) and which-key (500ms)

### Performance Enhancements

- **updatetime**: 200ms for faster completion and CursorHold events
- **timeoutlen**: 500ms for quicker which-key popup
- **undolevels**: 10,000 for extensive undo history without performance impact
- **Persistent undo**: Undo history survives Neovim restarts

## 🔄 Maintenance

### Updating Plugins

```fish
# Open Neovim and run:
:Lazy update

# Or sync everything:
:Lazy sync
```

### Managing Lock File

The `lazy-lock.json` file locks plugin versions for reproducibility. Commit this file when you want to lock the current plugin versions.

### Configuration Backup

This configuration is managed through a bare git repository (see `DOTFILES_MANAGEMENT.md`):

```fish
# Check status
config status

# Commit changes
config add .config/nvim/
config commit -m "Update Neovim configuration"
config push
```

## 🆘 Troubleshooting

### Common Issues

1. **Plugin not loading**: Check `:Lazy` for errors
2. **LSP not working**: Run `:LspInfo` to check status
3. **Keybinding conflicts**: Use `:map <key>` to check mappings
4. **Performance issues**: Run `:Lazy profile` to check load times

### Health Checks

Run Neovim health checks:

```vim
:checkhealth
:checkhealth lazy
:checkhealth lsp
```

### Reset Configuration

If you need to reset everything:

```fish
# Backup first
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup

# Re-clone configuration
config checkout
```

## 📚 Resources

### Quick Reference

For specific key bindings and implementation details, check these files:

- **Core Mappings**: `lua/config/keymaps.lua`
- **Plugin Configs**: `lua/plugins/*.lua` (each file documents its bindings)
- **Options**: `lua/config/options.lua`
- **Autocmds**: `lua/config/autocmds.lua`
- **LazyVim Extras**: `lazyvim.json`

### External Documentation

- [LazyVim Documentation](https://lazyvim.github.io/)
- [lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [Neovim Documentation](https://neovim.io/doc/)
- [Configuration Repository](https://github.com/philfuster/dotfiles)

## 🚀 Recent Improvements & Features

### Enhanced Core Configuration

- **Better Options**: Added performance tweaks, scroll offsets, smart search, and persistent undo
- **Enhanced Keymaps**: Added text movement, better indenting, centered navigation, and quick save
- **Smart Autocmds**: Automatic yank highlighting, directory creation, and quick close for special buffers

### New Plugin Additions

- **better-escape.nvim**: Multiple escape sequences (`jj`, `jk`) with optimized timing
- **todo-comments.nvim**: Beautiful TODO highlighting with navigation and Telescope integration
- **nvim-bqf**: Enhanced quickfix window experience

### Plugin Improvements

- **text-case.nvim**: Added Telescope integration for interactive case conversion
- **nvim-spider**: Fixed typo in description for better documentation
- **lazy.nvim**: Enabled caching for improved performance

### User Experience Enhancements

- **Visual Feedback**: Highlight yanked text for better copy/paste awareness
- **Smart Directory Creation**: Automatically create parent directories when saving files
- **Centered Navigation**: Search results and page scrolling stay centered
- **Quick Access**: Enhanced file navigation with multiple directory options
- **Session Management**: Added session selection to dashboard

---

*This configuration prioritizes developer productivity, performance, and maintainability while providing modern IDE-like features in Neovim.*
