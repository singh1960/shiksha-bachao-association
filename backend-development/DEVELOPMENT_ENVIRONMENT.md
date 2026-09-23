# Phase B.5 — Isolated Development Environment

**Status:** Preparation/validation plan only. No live provider has been configured.

## Objective

Provide a controlled, repeatable development environment for validating the Phase B.4 schema, RLS policies and security fixtures without using real personal data.

## Required separation

- Development: synthetic data only.
- Staging: synthetic/de-identified data only.
- Production: separate credentials, database, storage and authentication configuration.

## Environment variables

Use \`.env.example\` only as a template. Real credentials must be supplied through a local/private secret manager and must never be committed.

Required configuration categories:

- APP_ENV
- API_BASE_URL
- provider URL
- public client key
- development database connection
- private development storage bucket
- log level

## Validation sequence

1. Create an isolated development project only after organizational approval.
2. Configure development-only authentication.
3. Apply \`001_core_schema.sql\`.
4. Verify all expected tables, constraints and indexes.
5. Apply \`008_rls_grants.sql\`.
6. Verify RLS is enabled on every sensitive table.
7. Load only synthetic fixtures.
8. Run the Phase B.4 security assertions.
9. Record allow/deny results.
10. Test backup and restore using synthetic data.
11. Test private document storage with harmless dummy files.
12. Destroy/recreate the development environment to verify reproducibility.
13. Fix failures before any staging work.

## Migration validation checklist

- [ ] Clean database accepts schema migration.
- [ ] Re-running migration does not silently corrupt data.
- [ ] Foreign keys exist.
- [ ] Check constraints reject invalid values.
- [ ] Unique constraints reject duplicates.
- [ ] RLS is enabled on all sensitive tables.
- [ ] Anonymous access is denied.
- [ ] Member ownership isolation passes.
- [ ] Role separation passes.
- [ ] Protected status changes require approved server-side path.
- [ ] Documents remain private.
- [ ] Audit records cannot be edited by ordinary clients.
- [ ] Duplicate financial operations are prevented.
- [ ] Restore test succeeds.
- [ ] No secrets are committed.

## Reproducibility

A development environment is accepted only when it can be recreated from version-controlled migrations, policies and documented configuration without copying production data.

## Stop conditions

Stop and do not promote if:

- any cross-member record is visible;
- any unauthorized role can modify protected data;
- any document becomes public;
- audit history can be altered;
- a duplicate payment/disbursement can be created;
- secrets appear in source or logs;
- migration results differ unexpectedly between clean and repeat runs.

## Current state

This file defines the preparation procedure only. No provider project, database, authentication tenant or storage bucket has been created as part of Phase B.5.
