# CEP-002: Plugin Consolidation

**Status**: Implemented **Created**: 2025-09-23 **Updated**: 2025-09-23

## Summary

Consolidate overlapping plugin functionality and remove redundant plugins to
reduce complexity and improve maintainability of the configuration.

## Motivation

Current configuration has several instances of overlapping functionality:

- Both `mini.files` and `snacks_explorer` for file exploration with conflicting keybindings
- ~~Both `jj` keymap and `better-escape.nvim` for escape sequences~~ (Resolved in CEP-001)
- Multiple plugins that could be replaced by built-in LazyVim extras

## Specification

### Current State

- Using both mini.files and snacks_explorer (via LazyVim extras) with keybinding conflicts
- ~~better-escape.nvim duplicates existing `jj` mapping~~ (Fixed in CEP-001: removed manual mapping, kept better-escape)
- Some plugins loaded eagerly when they could be lazy

### Proposed Changes

#### 1. Dual File Explorer Strategy

After consideration, decided to keep BOTH file explorers for different use cases:
- **mini.files**: Primary file explorer for regular file browsing (quick, minimal interface)
- **snacks_explorer**: Secondary explorer for tree view sidebar and other advanced features

```lua
-- lua/plugins/extend-snacks-explorer.lua
-- Override keybindings to avoid conflicts
return {
  "folke/snacks.nvim",
  keys = {
    -- Disable conflicting bindings
    { "<leader>e", false },
    { "<leader>E", false },
    -- Add alternative bindings
    { "<leader>se", function() Snacks.explorer() end, desc = "Snacks Explorer (root)" },
    { "<leader>sE", function() Snacks.explorer.open(vim.uv.cwd()) end, desc = "Snacks Explorer (cwd)" },
  },
}
```

#### 2. ~~Remove better-escape.nvim~~ (No longer applicable)

After CEP-001 implementation, better-escape.nvim is now the sole escape method (manual `jj` mapping was removed).
This plugin provides more flexibility than a simple mapping.

#### 3. Lazy Load More Plugins

```lua
-- lua/plugins/git-conflict.lua
return {
  "akinsho/git-conflict.nvim",
  event = { "BufReadPre", "BufNewFile" },  -- Load when opening files to detect conflicts
  -- removed lazy = false
}

-- lua/plugins/smart-splits.lua
return {
  "mrjones2014/smart-splits.nvim",
  -- removed lazy = false, keys handle lazy loading
  keys = { ... }
}
```

### Files Affected

- `lua/plugins/extend-snacks-explorer.lua` - Created to override keybindings
- ~~`lua/plugins/disabled.lua`~~ - Not needed, keeping both explorers
- ~~`lua/plugins/better-escape.lua`~~ - Keeping after CEP-001 fixes
- `lua/plugins/git-conflict.lua` - Added event-based lazy loading
- `lua/plugins/smart-splits.lua` - Removed lazy = false for key-based loading
- ~~`lazyvim.json`~~ - No changes needed

## Alternatives Considered

1. **Remove one file explorer entirely**: Would lose useful functionality from each
2. **Keep conflicting keybindings**: Would cause unpredictable behavior
3. **Disable all snacks_explorer features**: Would lose useful sidebar/tree view functionality

## Backwards Compatibility

- No breaking changes - existing workflows preserved
- Users need to learn new `<leader>se` binding for snacks_explorer tree view
- mini.files remains on familiar `<leader>e` binding

## Implementation Checklist

- [x] Decide on file explorer strategy (keep both with different roles)
- [x] Create extend-snacks-explorer.lua to override keybindings
- [x] Keep better-escape.lua (already fixed in CEP-001)
- [x] Add lazy loading to git-conflict
- [x] Add lazy loading to smart-splits
- [x] Test file explorer keybindings
- [x] Update personal documentation (CEP-002 itself)

## Results

### Testing Notes

- Created `lua/plugins/extend-snacks-explorer.lua` to override conflicting keybindings
- mini.files retains primary keybindings (`<leader>e`, `<leader>E`)
- snacks_explorer moved to `<leader>se` and `<leader>sE` for tree view functionality
- Both explorers coexist without conflicts
- git-conflict now loads on BufReadPre/BufNewFile events to detect conflicts
- smart-splits lazy loads via key handlers

### Performance Impact

- No performance impact from dual explorer strategy (only one loads at a time)
- Improved startup time by lazy loading git-conflict and smart-splits
- git-conflict only loads when opening files (needed for conflict detection)
- smart-splits only loads when navigation keys are used

### Issues Encountered

- Initial keybinding conflict between mini.files and snacks_explorer
- Resolved by disabling default snacks_explorer bindings and adding alternatives
- No issues with lazy loading changes - plugins work as expected

### Final Outcome

**SUCCESS** - All objectives achieved:
1. **Dual explorer strategy**: mini.files for quick browsing, snacks_explorer for tree view
2. **Clear keybinding separation**: No conflicts between explorers
3. **Optimized plugin loading**: Both git-conflict and smart-splits now lazy load
4. **Maintained functionality**: All features still work as expected

The configuration is now cleaner, more efficient, and eliminates redundant functionality while preserving useful features from each plugin.

## References

- [LazyVim extras documentation](https://www.lazyvim.org/extras)
- Related CEPs: CEP-001 (Performance Optimizations)
