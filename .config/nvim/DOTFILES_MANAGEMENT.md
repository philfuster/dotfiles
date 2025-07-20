# Dotfiles Management with Bare Git Repository

This document explains how this Neovim configuration is managed using the bare git repository approach for dotfiles, based on the [Atlassian dotfiles tutorial](https://www.atlassian.com/git/tutorials/dotfiles).

## How It Works

### The Bare Repository Approach

Instead of using symlinks or copying files, this setup uses a **bare git repository** stored in `~/.cfg/` that treats your entire home directory (`$HOME`) as the working tree. This allows you to:

- Track dotfiles in their natural locations
- Use normal git commands through a special `config` alias/function
- Avoid symlink complexity
- Keep different configurations for different machines using branches
- Maintain a clean separation between dotfiles and regular git repositories

### Key Components

1. **Bare Repository**: `~/.cfg/` - Contains git metadata but no working files
2. **Working Tree**: `$HOME` - Your entire home directory acts as the working tree
3. **Config Function**: A fish shell function that wraps git commands to use the bare repo
4. **Hidden Untracked Files**: `status.showUntrackedFiles = no` prevents clutter

## Fish Shell Integration

The `config` function is defined in `~/.config/fish/config.fish`:

```fish
function config --wraps /usr/bin/git --description 'alias config=/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end
```

This function replaces the bash alias from the original tutorial and works seamlessly with fish shell.

## Managing Your Neovim Configuration

### Basic Operations

Use `config` instead of `git` for all dotfile operations:

```fish
# Check status of tracked dotfiles
config status

# Add files to tracking
config add .config/nvim/lua/plugins/new-plugin.lua

# Commit changes
config commit -m "Add new Neovim plugin configuration"

# Push to remote repository
config push

# Pull updates from remote
config pull
```

### Tracking New Neovim Files

When you create new configuration files:

```fish
# Add a new plugin configuration
config add .config/nvim/lua/plugins/my-new-plugin.lua

# Add multiple files at once
config add .config/nvim/lua/plugins/*.lua

# Add entire new directories
config add .config/nvim/after/
```

### Viewing Changes

```fish
# See what's changed
config status

# See detailed diff
config diff

# See what files are tracked
config ls-files | grep nvim
```

### Finding Untracked Files

Since `showUntrackedFiles` is set to `no`, use these methods to find untracked files:

```fish
# Method 1: Override the setting temporarily
config -c status.showUntrackedFiles=normal status

# Method 2: Check specific directory
cd ~/.config && find . -name "*.lua" -o -name "*.json" -o -name "*.toml" | grep -v "$(config ls-files)"
```

## Neovim-Specific Workflow

### Daily Workflow

1. **Make configuration changes** in your Neovim files
2. **Test the changes** to ensure they work correctly
3. **Stage the changes**: `config add .config/nvim/`
4. **Commit with descriptive message**: `config commit -m "Update LSP configuration for better diagnostics"`
5. **Push to remote**: `config push`

### Managing Plugin Lock Files

The `lazy-lock.json` file tracks exact plugin versions:

```fish
# Commit lock file after plugin updates
config add .config/nvim/lazy-lock.json
config commit -m "Update plugin versions"
```

### Branching for Different Setups

You can use branches for different machine configurations:

```fish
# Create a branch for work machine
config checkout -b work-machine

# Make work-specific changes
config add .config/nvim/lua/plugins/work-specific.lua
config commit -m "Add work-specific Neovim configuration"

# Switch back to main branch
config checkout main

# Merge common changes
config merge work-machine
```

## Repository Information

- **Remote Repository**: `git@github.com:philfuster/dotfiles.git`
- **Main Branch**: `main`
- **Local Bare Repo**: `~/.cfg/`

## Currently Tracked Neovim Files

Based on the current repository state, these Neovim files are tracked:

```
nvim/lua/config/autocmds.lua
nvim/lua/config/keymaps.lua
nvim/lua/config/lazy.lua
nvim/lua/config/options.lua
nvim/lua/plugins/extend-nvim-lspconfig.lua
nvim/lazy-lock.json
nvim/lazyvim.json
nvim/README.md
nvim/stylua.toml
nvim/init.lua
```

## Best Practices

### Do Track
- ✅ Configuration files (`.lua`, `.json`, `.toml`)
- ✅ Custom keymaps and options
- ✅ Plugin configurations
- ✅ Lock files for reproducible setups
- ✅ Documentation and README files

### Don't Track
- ❌ Cache files and temporary data
- ❌ Plugin installation directories (managed by lazy.nvim)
- ❌ Session files
- ❌ Swap files or backup files
- ❌ Personal/sensitive information

### Commit Message Conventions

Use clear, descriptive commit messages:

```fish
config commit -m "feat: add new LSP server configuration for Rust"
config commit -m "fix: resolve keybinding conflict in telescope"
config commit -m "refactor: reorganize plugin configurations"
config commit -m "docs: update plugin documentation"
```

## Troubleshooting

### If Config Command Doesn't Work

Check if the function is defined:
```fish
functions config
```

If not defined, add it to your `~/.config/fish/config.fish`:
```fish
function config --wraps /usr/bin/git --description 'alias config=/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end
```

### If Too Many Untracked Files Show

Ensure the setting is correct:
```fish
config config --get status.showUntrackedFiles
# Should return: no
```

If not set:
```fish
config config --local status.showUntrackedFiles no
```

## Recovery and Backup

### Cloning to a New Machine

```fish
# Clone the bare repository
git clone --bare git@github.com:philfuster/dotfiles.git $HOME/.cfg

# Define the config function
function config --wraps /usr/bin/git --description 'alias config=/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end

# Checkout files (backup any conflicts first)
config checkout

# Hide untracked files
config config --local status.showUntrackedFiles no
```

### Backing Up Before Major Changes

```fish
# Create a backup branch
config checkout -b backup-$(date +%Y%m%d)
config checkout main
```

---

*This configuration uses LazyVim as a base with custom extensions and modifications tracked through the bare git repository approach.*
