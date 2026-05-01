# Workflow Preferences

## Before committing
- Format and clean up the code before committing.

## Commit strategy
- If a recent commit already covers the same work, amend it (`--amend`) instead of creating a new commit.
- Multiple agents may be active concurrently — stage only the specific files you changed (`git add <file>…`), never `git add -A` or `git add .`.
- Use `git commit -m "message"` with literal newlines — never use `$()` command substitution (triggers security prompts)

## Summary
Format code -> stage surgically -> amend if aligned recent commit exists, otherwise new commit.
