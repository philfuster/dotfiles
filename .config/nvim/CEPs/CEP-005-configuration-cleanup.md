# CEP-005: Configuration Cleanup and Consolidation

**Status**: Implemented **Created**: 2025-01-02 **Updated**: 2025-01-02

## Summary

Simplify and consolidate Neovim configuration by removing bloat, fixing
configuration conflicts, and adopting LazyVim best practices for formatter
detection and LSP configuration.

## Motivation

Configuration review revealed several issues:

- Bloated files (example.lua with 198 unused lines)
- Conflicting file explorer setups (mini-files and snacks-explorer)
- Complex custom formatter detection that duplicated LazyVim functionality
- Split LSP configuration across two files with obsolete CEP references
- `guess-indent` overriding project `.editorconfig` files

These issues reduced clarity, added maintenance burden, and could cause team
workflow conflicts.

## Specification

### Current State

**Bloat:**

- `example.lua`: 198 lines of commented example code
- `extend-snacks-explorer.lua`: 43 lines duplicating mini-files functionality

**Formatter Detection:**

- 85 lines of custom config file detection logic
- Manual prettier/biome config searching with filesystem operations
- Redundant checks and potential performance issues

**LSP Configuration:**

- Split across two files (35 lines total)
- `lsp-diagnostics.lua` with obsolete CEP-003 reference
- `signs = true` overriding LazyVim's diagnostic icons

**Other Issues:**

- `guess-indent` set to `override_editorconfig = true` (dangerous)
- Both `snacks_explorer` and `snacks_picker` extras enabled

### Proposed Changes

#### 1. Remove Bloat

Delete unnecessary files:

```bash
rm lua/plugins/example.lua
rm lua/plugins/extend-snacks-explorer.lua
```

Update `lazyvim.json`:

```json
{
  "extras": [
    // Remove: "lazyvim.plugins.extras.editor.snacks_explorer"
    "lazyvim.plugins.extras.editor.mini-files",
    "lazyvim.plugins.extras.editor.snacks_picker"
  ]
}
```

#### 2. Simplify Formatter Detection

Replace custom logic with LazyVim's built-in detection:

```lua
-- lua/config/options.lua
vim.g.lazyvim_prettier_needs_config = true

-- lua/plugins/extend-conform.lua
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettier", "biome", stop_after_first = true },
      typescript = { "prettier", "biome", stop_after_first = true },
      -- ... other filetypes
    },
  },
}
```

**How it works:**

- LazyVim's prettier extra checks for config files automatically
- If config found → uses prettier
- If not found → falls back to biome
- Simple, tested, 22 lines vs 85 lines

#### 3. Consolidate LSP Configuration

Merge `lsp-diagnostics.lua` and `extend-nvim-lspconfig.lua`:

```lua
-- lua/plugins/extend-nvim-lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    format_notify = true,
    diagnostics = {
      virtual_text = {
        spacing = 2,  -- Tighter than LazyVim default (4)
        source = false,
      },
      float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    },
  },
}
```

**Key fixes:**

- Remove `signs = true` (was overriding LazyVim's icons)
- Remove CEP-003 reference
- Use `opts.diagnostics` table (LazyVim passes to `vim.diagnostic.config`)
- Only override settings that differ from defaults

#### 4. Fix guess-indent Configuration

```lua
-- lua/plugins/guess-indent.lua
return {
  "nmac427/guess-indent.nvim",
  opts = {
    auto_cmd = true,
    override_editorconfig = false,  -- Respect project standards
  }
}
```

### Files Affected

**Deleted:**

- `lua/plugins/example.lua` - Removed bloat
- `lua/plugins/extend-snacks-explorer.lua` - Consolidated into mini-files
- `lua/plugins/lsp-diagnostics.lua` - Merged into extend-nvim-lspconfig

**Modified:**

- `lua/config/options.lua` - Added `lazyvim_prettier_needs_config = true`
- `lua/plugins/extend-conform.lua` - Simplified to 22 lines
- `lua/plugins/extend-nvim-lspconfig.lua` - Consolidated LSP config (21 lines)
- `lua/plugins/guess-indent.lua` - Fixed editorconfig override
- `lazyvim.json` - Removed snacks_explorer extra

## Alternatives Considered

### 1. Custom Formatter Detection with Conditions

**Approach:** Keep elaborate custom conditions checking for config files

**Why not chosen:**

- 85 lines of custom code vs 22 lines using LazyVim
- Duplicate logic (prettier check in multiple places)
- Performance concerns (multiple filesystem searches)
- LazyVim's approach is battle-tested

### 2. Keep LSP Files Separate

**Approach:** Maintain `lsp-diagnostics.lua` and `extend-nvim-lspconfig.lua`

**Why not chosen:**

- Artificial separation for same plugin
- CEP-003 reference obsolete
- Harder to find all LSP settings
- Only 35 lines total - consolidation makes sense

### 3. Remove guess-indent Entirely

**Approach:** Rely solely on LazyVim's editorconfig support

**Why not chosen:**

- guess-indent provides automatic detection when no config exists
- Useful for ad-hoc files without project structure
- Just needed configuration fix, not removal

## Backwards Compatibility

**Breaking changes:** None

**Behavior changes:**

- Formatter selection now requires config files (prettier) or uses biome default
- guess-indent respects `.editorconfig` (previously overrode it)
- LSP diagnostic icons preserved (were being overridden)

**Migration needed:** None - changes are improvements to existing behavior

## Implementation Checklist

- [x] Backup current configuration
- [x] Test LazyVim's simple formatter approach
- [x] Delete bloat files (example.lua, extend-snacks-explorer.lua)
- [x] Simplify extend-conform.lua
- [x] Consolidate LSP configs
- [x] Fix guess-indent configuration
- [x] Update lazyvim.json
- [x] Test formatter detection in multiple projects
- [x] Document changes (REVIEW-2025-01.md, IMPROVEMENTS-SUMMARY.md)

## Results

### Testing Notes

Tested formatter detection in three scenarios:

1. **Project with `.prettierrc`** → Prettier used ✓
2. **Project with `biome.json`** → Biome used ✓
3. **Project with no config** → Biome used (default) ✓

LSP diagnostics display correctly with LazyVim icons preserved.

### Performance Impact

**Positive impacts:**

- Reduced config parsing (removed 198 lines from example.lua)
- Simpler formatter detection (fewer filesystem operations)
- Faster config reads (fewer files to load)

**No regressions observed.**

### Issues Encountered

1. **Initial formatter test failed** - Formatters not found
   - **Cause:** Config not properly reloaded
   - **Resolution:** Restart Neovim, then worked correctly

2. **Confusion about LazyVim's diagnostics table**
   - **Cause:** Unclear how `opts.diagnostics` is processed
   - **Resolution:** Verified LazyVim passes it directly to
     `vim.diagnostic.config()`

### Final Outcome

**Successful implementation.** Configuration is:

- Cleaner (9/10 clarity, up from 6/10)
- Less bloated (9/10, up from 5/10)
- More maintainable (uses LazyVim best practices)
- Better documented (review files created)

**Net reduction:** ~250 lines removed/consolidated

**Recommendations for others:**

- Trust LazyVim's built-in features before custom solutions
- Use `lazyvim_prettier_needs_config` for multi-formatter projects
- Consolidate related configs into single files
- Regular config reviews catch accumulating bloat

## References

- [LazyVim LSP Documentation](https://www.lazyvim.org/plugins/lsp)
- [conform.nvim Documentation](https://github.com/stevearc/conform.nvim)
- [Neovim Diagnostic API](https://neovim.io/doc/user/diagnostic.html)
- Related CEPs: CEP-003 (superseded by this CEP)
- REVIEW-2025-01.md - Detailed configuration review
- IMPROVEMENTS-SUMMARY.md - Summary of changes made
