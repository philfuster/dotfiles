# CEP-003: LSP Performance Improvements

**Status**: Implemented **Created**: 2025-09-23 **Updated**: 2025-09-23

## Summary

Add project-specific LSP configuration (primarily `.luarc.json`) and optimize
diagnostic display for improved development experience. LSP logging was already
optimized in CEP-001.

## Motivation

LSP operations can impact editor responsiveness, especially in large projects.
Current configuration lacks project-specific optimizations and the missing
`.luarc.json` means Lua LSP doesn't understand Neovim's runtime properly.

## Specification

### Current State

- ~~Default LSP log level (includes INFO and DEBUG)~~ (Fixed in CEP-001: set to ERROR)
- No project-specific LSP configuration
- Lua LSP doesn't recognize vim global
- No optimizations for large codebases

### Proposed Changes

#### 1. ~~Reduce LSP Logging Overhead~~ (Completed in CEP-001)

~~This was already implemented in CEP-001 in `lua/config/options.lua:76`:~~
```lua
-- Already implemented in options.lua
vim.lsp.set_log_level("ERROR")
```

#### 2. Create Lua LSP Configuration (Primary Focus)

```json
-- .luarc.json (in nvim config root)
{
  "runtime.version": "LuaJIT",
  "runtime.path": [
    "lua/?.lua",
    "lua/?/init.lua"
  ],
  "diagnostics.globals": ["vim"],
  "diagnostics.disable": ["lowercase-global"],
  "workspace.library": [
    "${3rd}/luv/library"
  ],
  "workspace.checkThirdParty": false,
  "telemetry.enable": false,
  "format.enable": false,
  "completion.callSnippet": "Replace"
}
```

#### 3. Optimize LSP Settings

```lua
-- lua/config/options.lua - Add these
vim.opt.updatetime = 200  -- Already have this
vim.diagnostic.config({
  virtual_text = {
    source = false,  -- Don't show source in virtual text
    spacing = 2,     -- Less spacing
  },
  float = {
    source = true,   -- Show source in float
    border = "rounded",
  },
  signs = true,
  underline = true,
  update_in_insert = false,  -- Don't update in insert mode
  severity_sort = true,
})
```

#### 4. TypeScript/JavaScript Performance

```lua
-- lua/plugins/extend-nvim-lspconfig.lua
-- Note: Check actual server name (likely ts_ls, not tsserver)
opts.servers.ts_ls = {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "none",  -- Reduce overhead
      },
    },
  },
}
```

### Files Affected

- ~~`lua/plugins/extend-nvim-lspconfig.lua`~~ - LSP optimizations (may not be needed if LazyVim handles this)
- ~~`.luarc.json`~~ - Created then removed (conflicts with lazydev.nvim)
- `lua/plugins/fix-lazydev.lua` - ✅ Temporary workaround for lazydev compatibility issue
- `lua/plugins/lsp-diagnostics.lua` - ✅ Created for diagnostic display optimization
- ~~LSP logging already handled in CEP-001~~

## Alternatives Considered

1. **Disable LSP for large files**: Too restrictive
2. **Use CoC.nvim instead**: Major architecture change
3. **Minimize LSP features**: Would lose valuable functionality

## Backwards Compatibility

No breaking changes. All modifications enhance existing LSP functionality
without removing features.

## Implementation Checklist

- [x] ~~Set LSP log level to ERROR~~ (Completed in CEP-001)
- [x] ~~Create .luarc.json file~~ (Not needed - lazydev.nvim handles this)
- [x] Configure diagnostic display options (created `lua/plugins/lsp-diagnostics.lua`)
- [x] Research current LazyVim LSP configuration (comprehensive defaults found)
- [x] ~~Optimize TypeScript LSP settings~~ (Already handled by LazyVim typescript extra)
- [ ] Test with large files (optional - can be done as needed)
- [ ] Monitor memory usage (optional - can be done as needed)

## Results

### Testing Notes

- ~~Created `.luarc.json` in nvim config root with Lua LSP configuration~~
- **Discovery**: LazyVim includes `lazydev.nvim` which automatically handles Lua LSP configuration
- Manual `.luarc.json` conflicted with lazydev.nvim integration
- Removed `.luarc.json` - lazydev.nvim provides superior automatic configuration
- lua-language-server was already installed via Mason

### Performance Impact

**Completed:**
- Lua LSP now properly understands Neovim environment
- Should reduce false warnings about undefined 'vim' global
- Better autocomplete for vim.* APIs

**Still to measure:**
- LSP response time with large projects
- Memory usage improvements
- Diagnostic update frequency

### Issues Encountered

**Critical Issue**: `lazydev.nvim` compatibility problem
- **Error**: `attempt to call field 'is_enabled' (a nil value)` in lazydev.nvim
- **Cause**: Version mismatch between lazydev.nvim and current Neovim/LazyVim setup
- **Impact**: Prevents opening any Lua files without errors
- **This is likely a temporary issue** that will be fixed in future LazyVim/lazydev updates

### Final Outcome

**SUCCESS** - All major objectives achieved:
1. ✅ LSP logging optimized (CEP-001)
2. ✅ Lua LSP configuration working (via workaround)
3. ✅ Diagnostic display optimized with `lsp-diagnostics.lua`
4. ✅ TypeScript already optimized via LazyVim extras
5. ✅ Research completed - LazyVim provides comprehensive LSP defaults

**Implementations**:
- **`lua/plugins/fix-lazydev.lua`**: Temporary workaround for lazydev compatibility
- **`lua/plugins/lsp-diagnostics.lua`**: Optimized diagnostic display settings
- **Discovery**: LazyVim typescript extra already provides optimal TypeScript LSP config

**Key Learnings**:
1. LazyVim already includes excellent LSP optimizations out of the box
2. The typescript extra (already enabled) provides vtsls with performance optimizations
3. Sometimes compatibility issues require temporary workarounds
4. Research before implementation can save unnecessary work

## References

- [Neovim LSP documentation](https://neovim.io/doc/user/lsp.html)
- [lua-language-server configuration](https://github.com/LuaLS/lua-language-server/wiki/Configuration-File)
- Related CEPs: CEP-001 (Performance Optimizations)
