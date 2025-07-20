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
│       └── [custom plugins] # Additional plugin configurations
```

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

```lua
vim.g.lazyvim_prettier_needs_config = true
```

- Ensures Prettier only runs when a config file is present

### Keymaps (`lua/config/keymaps.lua`)

```lua
vim.api.nvim_set_keymap("i", "jj", "<Esc>", {
  noremap = true,
  silent = true,
})
```

- **`jj`** in insert mode → Quick escape to normal mode

### Auto Commands (`lua/config/autocmds.lua`)

- Currently uses LazyVim defaults
- Ready for custom auto commands

## 🔌 Custom Plugins

### Window & Navigation Management

#### Smart Splits (`smart-splits.lua`)

Enhanced window navigation with smart terminal multiplexer integration.

**Key Bindings:**

- `<Alt-h>` - Move to left window
- `<Alt-l>` - Move to right window
- `<Alt-j>` - Move to window below
- `<Alt-k>` - Move to window above

#### nvim-spider (`nvim-spider.lua`)

Smarter word motion that skips punctuation.

**Enhanced Motions:**

- `w` - Move to start of next word (smart)
- `e` - Move to end of word (smart)
- `b` - Move to start of previous word (smart)

### Text Manipulation

#### Rip Substitute (`rip-substitute.lua`)

Fast, interactive search and replace.

**Key Bindings:**

- `g/` - Open rip substitute interface (normal/visual mode)

#### Text Case (`text-case.lua`)

Text case conversion utilities.

**Commands:**

- `:Subs` - Text substitution
- `:TextCaseStartReplacingCommand` - Start case replacement

### Git Integration

#### Git Conflict (`git-conflict.lua`)

Enhanced git conflict resolution.

**Key Bindings:**

- `<leader>ho` - Choose ours (current branch)
- `<leader>ht` - Choose theirs (incoming branch)
- `<leader>h0` - Choose none (delete conflict)
- `<leader>hb` - Choose both (keep both changes)
- `]x` - Next conflict
- `[x` - Previous conflict
- `<leader>gx` - List all conflicts in quickfix
- `<leader>gr` - Refresh conflicts

### Development Tools

#### Guess Indent (`guess-indent.lua`)

Automatically detects and sets indentation.

#### TS Comments (`ts-comments.lua`)

Enhanced commenting with TreeSitter integration.

### Extended LazyVim Plugins

The configuration extends several LazyVim plugins with custom settings:

- **`extend-bufferline.lua`** - Enhanced buffer line customization
- **`extend-gitsigns.lua`** - Extended git signs functionality
- **`extend-mini-files.lua`** - Mini files explorer enhancements
- **`extend-mini-surround.lua`** - Surround text object extensions
- **`extend-neotest.lua`** - Testing framework customizations
- **`extend-nvim-dap.lua`** - Debug adapter protocol extensions
- **`extend-nvim-lspconfig.lua`** - LSP configuration extensions
- **`extend-snacks.lua`** - Snacks plugin customizations

### Disabled Plugins

#### Neo-tree (`disabled.lua`)

Neo-tree file explorer is disabled in favor of mini-files and snacks explorer.

## 🎯 Key Features & Workflows

### Development Workflow

1. **File Navigation**
   - Use `<leader>ff` (from LazyVim) for fuzzy file finding
   - Use mini-files with `<leader>e` for tree-style navigation
   - Use `<Alt-hjkl>` for smart window navigation

2. **Code Editing**
   - `jj` for quick escape from insert mode
   - Smart word motions with `w`, `e`, `b`
   - GitHub Copilot for AI-assisted coding
   - Text case conversion utilities

3. **Git Integration**
   - Built-in git signs and blame
   - Advanced conflict resolution with git-conflict
   - Comprehensive git operations through LazyVim

4. **Search & Replace**
   - Use `g/` for interactive search/replace with rip-substitute
   - LazyVim's built-in telescope search capabilities

5. **Testing & Debugging**
   - Integrated testing with neotest
   - Debug Adapter Protocol (DAP) support
   - Multiple language support

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

- [LazyVim Documentation](https://lazyvim.github.io/)
- [lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [Neovim Documentation](https://neovim.io/doc/)
- [Configuration Repository](https://github.com/philfuster/dotfiles)

---

*This configuration prioritizes developer productivity, performance, and maintainability while providing modern IDE-like features in Neovim.*
