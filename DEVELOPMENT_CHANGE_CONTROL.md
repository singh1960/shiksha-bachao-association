# Shiksha Bachao Association — Development & Change-Control Guide

## Purpose

This guide is the working foundation for future development of the Shiksha Bachao Association website. It is designed to prevent accidental structural changes and keep the current release stable.

## Golden Rule

**One requirement → one controlled change → one verification → one recorded commit.**

## Development Checklist

### A. Before development
- [ ] Confirm the exact feature or problem.
- [ ] Identify only the files that need to change.
- [ ] Search for existing references before creating a new file.
- [ ] Fetch the latest version of every file that will be edited.
- [ ] Check whether the requested feature already exists elsewhere.
- [ ] Do not modify unrelated pages.

### B. During development
- [ ] Preserve the current three-language structure.
- [ ] Preserve existing navigation unless the task specifically changes navigation.
- [ ] Keep `welfare-scheme.html` as the single authoritative welfare-form listing.
- [ ] Do not duplicate the 30 individual welfare-form links on other pages.
- [ ] Reuse existing assets where possible.
- [ ] Avoid unnecessary CSS/JavaScript rewrites.
- [ ] Do not delete files without a confirmed reference audit.

### C. After development
- [ ] Re-fetch every changed file.
- [ ] Check expected text/links are present.
- [ ] Check unintended text/links are absent.
- [ ] Check internal references for the changed area.
- [ ] Check Hindi/English/Marathi behavior if multilingual code was touched.
- [ ] Record the commit SHA.
- [ ] Record any deleted files and the reason.
- [ ] If a structural change was made, perform a broader repository audit.

## Release Gate

A change should not be treated as complete until all applicable items below pass:

- [ ] HTML loads correctly
- [ ] Internal links resolve
- [ ] No unintended duplicate links
- [ ] No obsolete references introduced
- [ ] No unrelated files changed
- [ ] Language switching remains functional
- [ ] Mobile layout remains intact
- [ ] Desktop layout remains intact
- [ ] Accessibility basics remain intact
- [ ] Commit is recorded

## Change Classification

### Level 1 — Content-only
Examples:
- correcting text
- updating a description
- fixing a spelling error

Verification:
- changed text only
- no navigation impact

### Level 2 — Page-level
Examples:
- adding a section
- adding a form link
- modifying a page component

Verification:
- page links
- language behavior
- responsive layout
- affected references

### Level 3 — Structural
Examples:
- moving files
- changing navigation architecture
- changing shared JavaScript/CSS
- deleting or renaming multiple files

Verification:
- full reference audit
- all affected pages
- mobile/desktop review
- release baseline review

## File Deletion Rule

A file may be deleted only when:
1. its purpose is identified;
2. repository references have been searched;
3. external/website use has been considered;
4. a replacement exists when required;
5. the deletion is recorded in the commit/message.

## Welfare Forms Rule

The current welfare-form system is:

**30 HTML forms → 3 languages → 1 authoritative page**

- Hindi: 10
- English: 10
- Marathi: 10

Do not create another parallel set of welfare forms unless a new version is intentionally approved.

## Versioning Rule

For future form revisions:
- Version 1.3 remains the current baseline.
- A revised form set should receive a new version number.
- Do not overwrite the baseline casually.
- Before publishing a new version, compare the complete set language-wise.

## Suggested Future Change Log

For every significant release, record:
- Date
- Feature/change
- Files changed
- Files added
- Files deleted
- Verification performed
- Commit SHA
- Release status

## Stable Foundation Status

Current foundation: **STABLE / RELEASE-READY**

The next development cycle should start from this baseline and avoid unnecessary redesign.
