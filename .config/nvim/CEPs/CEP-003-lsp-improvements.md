# CEP-003: LSP Performance Improvements

**Status**: Partially Implemented **Created**: 2025-09-23 **Updated**: 2025-09-23

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
- `lua/config/options.lua` - Diagnostic config (pending)
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
- [ ] Configure diagnostic display options
- [ ] Research current LazyVim LSP configuration
- [ ] Optimize TypeScript LSP settings (if not already handled by LazyVim)
- [ ] Test with large files
- [ ] Monitor memory usage

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

**WORKAROUND IMPLEMENTED** - Temporary fix for compatibility issue:
1. ❌ Manual `.luarc.json` caused conflicts with lazydev.nvim
2. ⚠️ `lazydev.nvim` has compatibility issues with current setup
3. ✅ Implemented workaround: Disabled lazydev.nvim, added manual LSP config
4. ⏳ Diagnostic display optimizations still pending
5. ⏳ TypeScript optimizations need research

**Workaround Details** (`lua/plugins/fix-lazydev.lua`):
- Disabled problematic `lazydev.nvim`
- Manually configured lua_ls with Neovim-specific settings
- Provides same benefits (vim global recognition, autocomplete, etc.)
- **This is temporary** - should be removed when lazydev.nvim is fixed upstream

**Key Learning**: Sometimes LazyVim's automatic features can have compatibility issues. Having a manual fallback configuration is valuable until upstream fixes arrive.

## References

- [Neovim LSP documentation](https://neovim.io/doc/user/lsp.html)
- [lua-language-server configuration](https://github.com/LuaLS/lua-language-server/wiki/Configuration-File)
- Related CEPs: CEP-001 (Performance Optimizations)
