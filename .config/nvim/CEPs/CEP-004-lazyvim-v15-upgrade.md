# CEP-004: LazyVim v15 Upgrade

**Status**: Completed **Created**: 2025-09-23 **Updated**: 2025-09-23

## Summary

Upgrade LazyVim from v14.15.1 to v15.0.0 to benefit from modernized
configuration, improved performance, and latest plugin ecosystem updates. This
is a major version upgrade with breaking changes that require careful migration.

## Motivation

LazyVim v15.0.0 (released September 17, 2025) brings significant improvements:

- Better LSP performance and capabilities
- Modernized TreeSitter integration
- Improved completion with blink.cmp as default
- Performance optimizations throughout

Staying on v14.x means missing security updates, bug fixes, and new features.

## Specification

### Current State

- Running LazyVim v14.15.1
- Neovim v0.11.1 (meets v15 requirements)
- Has compatibility issues with lazydev.nvim (may be fixed in v15)
- Custom configurations in place (CEP-001, CEP-002, CEP-003)

### Breaking Changes in v15

#### 1. Neovim Version Requirement

- **Requires**: Neovim >= 0.11.2 (currently have 0.11.1)
- **Action Required**: Update Neovim first

#### 2. TreeSitter Migration

- Migrated to nvim-treesitter main branch
- **Requirements**:
  - tree-sitter-cli tool installed
  - Compatible C compiler (zig no longer supported)
  - gzip installed on system

#### 3. Completion Engine Change

- blink.cmp is now the default completion engine
- May affect custom completion configurations

### Upgrade Process

#### Step 1: Pre-Upgrade Checklist

- [ ] Backup current configuration
      (`cp -r ~/.config/nvim ~/.config/nvim.backup`)
- [ ] Document custom modifications
- [ ] Update Neovim to >= 0.11.2
- [ ] Install tree-sitter-cli: `npm install -g tree-sitter-cli`
- [ ] Verify gzip is installed: `which gzip`

#### Step 2: Update LazyVim

```bash
# Update lazy-lock.json to allow v15
nvim --headless "+Lazy! update LazyVim" +qa

# Or manually in Neovim
:Lazy update LazyVim
```

#### Step 3: Post-Upgrade Tasks (Optional - test as you go)

- [ ] Review and test all custom plugins
- [ ] Check if lazydev.nvim issue is resolved (remove fix-lazydev.lua if so)
- [ ] Test LSP functionality
- [ ] Verify TreeSitter parsers are working
- [ ] Test completion engine (blink.cmp)

### Expected Benefits

1. **Performance**:

   - LSP folds enabled when available
   - Only highlight installed TreeSitter languages
   - LazyDev optimized for Lua files only

2. **Stability**:

   - Updated Mason v2
   - Improved language server configurations
   - May fix lazydev.nvim compatibility issue

3. **Features**:
   - blink cmdline completions
   - Better LSP capabilities
   - Modernized plugin ecosystem

### Risk Assessment

**Low Risk**:

- Neovim version already close to requirement
- Configuration is well-documented via CEPs
- Easy rollback via backup

**Medium Risk**:

- Custom plugins may need adjustments
- Completion engine change might affect workflow

**Mitigation**:

- Full backup before upgrade
- Test in stages
- Keep fix-lazydev.lua until verified not needed

## Alternatives Considered

1. **Stay on v14**: Not recommended - will miss updates and fixes
2. **Pin to v14 permanently**: Only if unable to update Neovim
3. **Fresh install**: Would lose custom configurations

## Backwards Compatibility

- No downgrade path after v15 migration
- Must maintain Neovim >= 0.11.2 going forward
- Some plugins may need updates to work with v15

## Implementation Checklist

- [x] Update Neovim to >= 0.11.2 (upgraded to v0.11.4)
- [x] Install tree-sitter-cli
- [x] Backup configuration
- [x] Update LazyVim to v15 (v15.3.0)
- [x] Test basic functionality
- [x] Review custom plugins compatibility
- [x] Remove fix-lazydev.lua if issue resolved (removed - no longer needed)
- [x] Update lazy-lock.json
- [x] Document any new issues

## Results

### Testing Notes

**Date**: 2025-09-23 **Upgrade Path**: v14.15.1 → v15.3.0

Successfully upgraded LazyVim to v15.3.0 with the following steps:

1. Updated Neovim from v0.11.1 to v0.11.4
2. Installed tree-sitter-cli via npm
3. Cleared old parser binaries and rebuilt with new tree-sitter-cli
4. All 32 TreeSitter parsers compiled successfully in new location

### Performance Impact

- Parser compilation now uses tree-sitter-cli instead of built-in compiler
- Parsers moved from `~/.local/share/nvim/lazy/nvim-treesitter/parser/` to
  `~/.local/share/nvim/site/parser/`
- Initial parser compilation took ~1 minute for all 32 parsers
- No noticeable performance degradation in normal usage

### Issues Encountered

1. **Initial Neovim version incompatibility**

   - Error: "LazyVim requires Neovim >= 0.11.2"
   - Solution: Upgraded Neovim from 0.11.1 to 0.11.4

2. **Missing tree-sitter-cli**

   - TreeSitter parsers failed to compile
   - Solution: Installed via `npm install -g tree-sitter-cli`

3. **Old parser binaries**
   - Had to manually remove old .so files from previous location
   - Solution: `rm -rf ~/.local/share/nvim/lazy/nvim-treesitter/parser/*.so`

### Final Outcome

✅ **Success** - Upgrade completed successfully

- LazyVim v15.3.0 running stable
- All TreeSitter parsers compiled and functional
- LSP and completion systems working properly
- No custom configuration breakage detected
- **Bonus**: Removed fix-lazydev.lua workaround - no longer needed in v15

## References

- [LazyVim v15.0.0 Release](https://github.com/LazyVim/LazyVim/releases/tag/v15.0.0)
- [LazyVim v15.x Migration Guide](https://github.com/LazyVim/LazyVim/issues/6421)
- [LazyVim Changelog](https://github.com/LazyVim/LazyVim/blob/main/CHANGELOG.md)
- Related CEPs: All previous CEPs may need review post-upgrade
