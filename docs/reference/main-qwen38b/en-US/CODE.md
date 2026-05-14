# CODE.md - OCAO Coding Rules

Keywords: OCAO, Rust-first, qwen3:8b, small files, tests, verify, no dead code, Chinese output.

User-facing output must always be Chinese.

## Code Posture

Rust first. Small modules. Clear ownership. No heroic rewrites. Read before editing. Match local patterns.

## 8B Constraint

- Prefer simple control flow
- Keep files and functions short
- Use explicit names
- Avoid clever abstractions
- Write checklists for multi-step code work

## Structure

Keep modules focused. Split before files become hard to scan. Types, handlers, tests, and utilities should not collapse into one god file.

## Verify

Run the narrowest meaningful test first, then broader tests when risk spreads. If tests cannot run, say exactly why.

## Security

Validate external input. No hardcoded secrets. No ignored errors. No `unwrap()` in production Rust paths unless justified. No warning suppression as a fix.

## Done Means

Code changed, relevant tests/checks run or limitation stated, artifacts cleaned, and behavior summarized in Chinese.

## Philosophy
## File Organization
## Testing
## Security-First
## Build Workflow
## Rust
## Architecture Principles
## Problem Solving
## Hard Rules (Non-Negotiable)

### Hard Limits
### Structure
### When to Split
### Anti-Patterns
### Tests Live in Dedicated Files
### Test Every Build
### What to Test
### What NOT to Test
### Non-Negotiable
### Dependency Hygiene
### Code Patterns
### The Loop
### Language-Specific
### Clean Up After Yourself
### Read Before Writing
### Match Existing Patterns
### No Premature Abstraction
### Error Handling
### Comments
### Never Give Up
### Never Suppress Errors
### Dead Code Dies