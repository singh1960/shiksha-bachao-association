# Phase B.6.2 — Development Provider Project Setup Specification

**Status:** Ready for controlled setup
**Scope:** Development only
**Production impact:** None

## Objective

Define the exact provider-side setup required before executing the B.6 database migrations.

## Target

The current blueprint uses Supabase as the provisional development implementation target. This document does not constitute a final production-provider selection.

## Project requirements

Create a completely separate development project with:

- Development-only project/environment name.
- Separate development authentication configuration.
- Empty/disposable PostgreSQL database.
- Private development storage bucket for dummy documents.
- No production database connection.
- No production authentication users.
- No production storage files.
- No real member/teacher data.
- Backup/restore capability enabled or otherwise available for the development environment.

## Security configuration before migration

1. Keep provider-generated credentials in the provider's secure secret/configuration mechanism.
2. Do not commit secrets to Git.
3. Do not place service-role credentials in browser/static website code.
4. Keep .env.example as placeholders only.
5. Restrict administrative database access to the approved development operators.
6. Keep storage private by default.
7. Enable provider audit/operational logging where available.
8. Record only non-secret project metadata in the repository evidence register.

## Database readiness gate

Before applying migrations, verify:

- [ ] PostgreSQL database is reachable through the approved secure channel.
- [ ] Database is development-only.
- [ ] No application tables containing real data exist.
- [ ] pgcrypto extension can be enabled or is already available.
- [ ] Migration user has only the permissions required for the development migration.
- [ ] A clean backup/snapshot can be created.

## Authentication readiness gate

Create only synthetic test actors after schema setup is ready. Suggested logical actors:

- member_a
- member_b
- verification_officer
- welfare_committee
- finance_officer
- auditor
- super_admin

Use provider-generated development identities. Never reuse production identities.

## Storage readiness gate

Create a private development bucket, for example:

welfare-documents-dev

Use harmless dummy files only. The bucket must not be public.

## Handoff record

After setup, record only:

- provider name;
- non-secret project identifier;
- environment = development;
- database readiness = PASS/FAIL;
- authentication readiness = PASS/FAIL;
- storage readiness = PASS/FAIL;
- backup readiness = PASS/FAIL.

Do not record passwords, API keys, service-role keys, access tokens or connection strings.

## Stop conditions

Do not continue to migration execution if:

- the project is not isolated;
- production data or users are present;
- storage is public;
- credentials are exposed;
- the project cannot be cleanly destroyed/recreated;
- backup/snapshot capability is unavailable.

## Current boundary

No provider project is created by this repository change. This is a controlled setup specification. Actual provider creation and migration execution require authorized access to the selected provider account.

**Next gate:** provider project created and readiness checklist passed → B.6.3 migration execution.