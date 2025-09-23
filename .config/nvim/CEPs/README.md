# Config Enhancement Proposals (CEPs)

## What are CEPs?

Config Enhancement Proposals (CEPs) are structured documents that describe
planned improvements, experiments, and changes to my personal Neovim
configuration. Inspired by Python's PEP system, CEPs provide a systematic way
to:

- Document configuration changes before implementing them
- Track the rationale behind decisions
- Maintain a history of what was tried, what worked, and what didn't
- Plan complex changes that span multiple files or plugins

## CEP Structure

Each CEP follows a standard format:

- **Header**: CEP number, title, status, created date
- **Summary**: Brief description of the proposed change
- **Motivation**: Why this change is needed
- **Specification**: Detailed technical implementation
- **Alternatives**: Other approaches considered
- **Implementation Notes**: Actual results and learnings

## Status Types

- **Draft**: Initial proposal, still being refined
- **Active**: Approved and currently being implemented
- **Testing**: Implementation complete, evaluating results
- **Stable**: Successfully implemented and working well
- **Rejected**: Decided not to implement
- **Superseded**: Replaced by another CEP
- **Deferred**: Postponed for future consideration

## CEP Index

| CEP                                         | Title                        | Status | Created    | Updated |
| ------------------------------------------- | ---------------------------- | ------ | ---------- | ------- |
| [001](CEP-001-performance-optimizations.md) | Performance Optimizations    | Draft  | 2025-09-23 | -       |
| [002](CEP-002-plugin-consolidation.md)      | Plugin Consolidation         | Draft  | 2025-09-23 | -       |
| [003](CEP-003-lsp-improvements.md)          | LSP Performance Improvements | Draft  | 2025-09-23 | -       |

## Process

1. **Create**: Copy `template.md` to `CEP-XXX-short-name.md`
2. **Draft**: Fill out the proposal sections
3. **Review**: Consider implications and alternatives
4. **Implement**: Make the changes in a controlled manner
5. **Evaluate**: Test and document results
6. **Update**: Mark as Stable, Rejected, or iterate

## Guidelines

- Keep CEPs focused on a single concern or related set of changes
- Document both successes and failures - failed experiments are valuable
  learning
- Include specific file paths and code snippets
- Update status promptly to reflect current state
- Link related CEPs when changes build on each other

## Why This Exists

Neovim configurations tend to grow organically and can become complex over time.
CEPs help bring intentionality to config changes, making it easier to:

- Remember why specific decisions were made
- Rollback changes that didn't work out
- Share configuration strategies with others
- Avoid repeating failed experiments
