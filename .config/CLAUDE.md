# CLAUDE.md - Dotfiles Management Guide

This file provides guidance to Claude Code (claude.ai/code) when working with
the bare git repository that manages dotfiles across this system.

## Repository Overview

This is a **bare git repository** approach for dotfiles management, where:

- **Repository Location**: `~/.cfg/` (bare repository, no working directory)
- **Working Tree**: `$HOME` (entire home directory serves as working tree)
- **Remote Origin**: `git@github.com:philfuster/dotfiles.git`
- **Main Branch**: `main`
- **User**: Phil Fuster (paf@storis.com)

## How the Bare Repository Works

### Core Concept

Unlike traditional git repositories, this setup uses a **bare repository** stored
in `~/.cfg/` that treats the entire home directory as its working tree. This
approach eliminates the need for symlinks or copying files between a repository
and their actual locations.

### Fish Shell Integration

All git operations are performed through a fish function called `config`:

```fish
function config --wraps /usr/bin/git --description 'alias config=/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end
```

**Important**: When working in bash/sh environments (like Claude Code), use the
full git command instead:
```bash
/usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf [git-commands]
```

## Currently Tracked Configuration Areas

The repository tracks configurations for these systems:

### Primary Configurations
- **fish shell**: `~/.config/fish/` - Shell configuration, functions, completions
- **neovim**: `~/.config/nvim/` - Complete Neovim/LazyVim configuration
- **tmux**: `~/.config/tmux/` - Terminal multiplexer configuration
- **lazygit**: `~/.config/lazygit/` - Git TUI configuration

### Support Files
- **Prettier**: `~/.config/.prettierrc` - Code formatting configuration
- **Documentation**: `~/.config/DOTFILES_MANAGEMENT.md` - Detailed usage guide
- **Repository**: `~/.gitignore` - Global git ignore rules

### Total Files Tracked
The repository currently tracks approximately 45+ configuration files across
these different systems.

## Essential Commands

### Repository Status and Information

```bash
# Check status (from home directory)
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf status

# List all tracked files
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf ls-files

# Show what's changed
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf diff

# View commit history
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf log --oneline -10
```

### Adding and Committing Changes

```bash
# Add specific file
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf add .config/nvim/lua/plugins/new-plugin.lua

# Add directory recursively
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf add .config/fish/functions/

# Commit changes
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf commit -m "feat: add new plugin configuration"

# Push to remote
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf push
```

### Finding Untracked Files

Since `status.showUntrackedFiles=no` is configured, untracked files won't show
in status. To find them:

```bash
# Override setting temporarily
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf -c status.showUntrackedFiles=normal status

# Find specific file types in config directories
find ~/.config -name "*.lua" -o -name "*.fish" -o -name "*.yml" | grep -v "$(cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf ls-files)"
```

## Repository Maintenance Operations

### Synchronization

```bash
# Pull latest changes from remote
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf pull

# Push local changes to remote
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf push

# Fetch without merging
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf fetch
```

### Branch Management

```bash
# List branches
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf branch -a

# Create feature branch
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf checkout -b feature/new-config

# Switch branches
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf checkout main

# Merge changes
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf merge feature/new-config
```

### Repository Health

```bash
# Check repository integrity
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf fsck

# Garbage collection
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf gc

# Show repository statistics
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf count-objects -v
```

## Best Practices for Dotfiles Management

### What to Track
- ✅ Configuration files (`.lua`, `.fish`, `.yml`, `.toml`)
- ✅ Custom scripts and functions
- ✅ Plugin configurations and settings
- ✅ Lock files for reproducible setups
- ✅ Documentation and README files

### What NOT to Track
- ❌ Cache files and temporary data
- ❌ Compiled binaries or build artifacts
- ❌ Logs and session files
- ❌ Personal/sensitive information (API keys, passwords)
- ❌ Large binary files or media
- ❌ System-generated files that change frequently

### Commit Message Conventions

Use conventional commit format:

```bash
feat: add new fish function for git operations
fix: resolve tmux session management issue
docs: update neovim plugin documentation
refactor: reorganize fish shell configuration
chore: update plugin lock files
```

### File Organization Strategy

The repository follows these organization patterns:

```
~/.config/
├── fish/           # Shell configuration
│   ├── config.fish
│   ├── functions/
│   └── completions/
├── nvim/           # Neovim configuration
│   ├── init.lua
│   ├── lazy-lock.json
│   └── lua/
├── tmux/           # Terminal multiplexer
├── lazygit/        # Git TUI
└── .prettierrc     # Formatting rules
```

## Common Workflows

### Adding New Configuration

1. **Create the configuration** in its natural location
2. **Test the configuration** to ensure it works
3. **Add to tracking**: `[git-command] add .config/app/config-file`
4. **Commit with message**: `[git-command] commit -m "feat: add app configuration"`
5. **Push to remote**: `[git-command] push`

### Updating Existing Configuration

1. **Modify the configuration** files
2. **Test changes** thoroughly
3. **Review changes**: `[git-command] diff`
4. **Stage changes**: `[git-command] add .config/modified-files`
5. **Commit**: `[git-command] commit -m "update: improve app configuration"`
6. **Push**: `[git-command] push`

### Setting Up on New Machine

```bash
# Clone bare repository
git clone --bare git@github.com:philfuster/dotfiles.git $HOME/.cfg

# Set up fish function (add to fish config)
function config --wraps /usr/bin/git --description 'alias config=/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end

# Checkout files (backup conflicts first)
cd ~ && /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout

# Hide untracked files
cd ~ && /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no
```

## Troubleshooting

### Repository Access Issues

If git commands fail, verify:
1. **Bare repository exists**: `ls -la ~/.cfg/`
2. **Correct paths used**: Always use absolute paths `/home/paf/.cfg/`
3. **Working directory**: Run commands from `/home/paf` or use absolute paths

### Untracked Files Showing

If too many untracked files appear:
```bash
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf config --get status.showUntrackedFiles
# Should return: no
```

If not set:
```bash
cd /home/paf && /usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf config --local status.showUntrackedFiles no
```

### Merge Conflicts

When pulling changes that conflict:
1. **Review conflicts**: `[git-command] status`
2. **Resolve manually** or use merge tools
3. **Stage resolved files**: `[git-command] add conflicted-files`
4. **Complete merge**: `[git-command] commit`

## Security Considerations

### Sensitive Information

- **Never track**: API keys, passwords, private keys
- **Use separate files**: Keep sensitive config in untracked files
- **Review before committing**: Always check `git diff` before commits
- **Use .gitignore**: Add patterns for sensitive files

### Access Control

- **SSH keys**: Use SSH for GitHub authentication
- **Repository privacy**: Keep dotfiles repository private if containing sensitive info
- **Branch protection**: Consider protecting main branch on GitHub

## Working with Claude Code

### Key Commands for Claude

When Claude Code works with this repository, use these patterns:

```bash
# Always work from home directory
cd /home/paf

# Use full git command syntax
/usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf [command]

# Check what's tracked in specific areas
/usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf ls-files | grep nvim
/usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf ls-files | grep fish

# Stage configuration changes
/usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf add .config/[app]/[files]

# Commit with conventional messages
/usr/bin/git --git-dir=/home/paf/.cfg/ --work-tree=/home/paf commit -m "type: descriptive message"
```

### Integration with Other Tools

This dotfiles setup integrates with:
- **Fish shell**: Primary shell environment
- **LazyVim**: Neovim configuration framework
- **Lazygit**: Git interface (configured via tracked config)
- **Tmux**: Terminal session management
- **Prettier**: Code formatting

---

*This bare repository approach provides clean, symlink-free dotfiles management
while maintaining all configurations in their natural locations.*