# Phase B.6.1 — Approved Development Provider Access & Handoff

**Status:** Prepared — awaiting explicit provider/project access  
**Scope:** Development only  
**Production impact:** None

## Objective

Prepare the minimum controlled handoff needed before the Phase B.6 live migration can be executed.

## Provider decision boundary

The repository blueprint currently names **Supabase as the provisional implementation target**, not as a final mandatory production selection. The development project must be isolated and must not contain production data.

## Access checklist

Before B.6 execution, confirm:

- [ ] Organization has approved the development provider.
- [ ] A new development-only project has been created.
- [ ] Project is separate from staging and production.
- [ ] Development database is empty or disposable.
- [ ] Development authentication is separate from production.
- [ ] Development storage bucket is private.
- [ ] No real member/teacher information has been imported.
- [ ] Database credentials are stored outside Git.
- [ ] `.env.example` remains credential-free.
- [ ] Backup/restore capability is available.
- [ ] A non-secret project/environment identifier is available for the evidence register.

## Required handoff information

Only these non-secret values need to be supplied to continue the execution workflow:

- provider/project name or non-secret identifier;
- confirmation that the project is development-only;
- confirmation that no production/personal data is present;
- confirmation that database access is available through the approved secure channel.

**Never paste passwords, API keys, service-role keys, access tokens, or database connection strings into GitHub files or ordinary chat.**

## Execution gate

Once the above conditions are satisfied:

1. Run `001_core_schema.sql`.
2. Run `010_migration_validation.sql`.
3. Run `008_rls_grants.sql`.
4. Run `010_migration_validation.sql` again.
5. Configure synthetic auth actors inside the development project.
6. Run `011_synthetic_security_fixtures.sql`.
7. Run `009_security_test_fixtures.sql`.
8. Record PASS/FAIL/BLOCKED results in `PHASE_B6_EXECUTION_EVIDENCE.md`.
9. Test private dummy-document access.
10. Perform backup/restore.
11. Destroy and recreate the development environment.
12. Repeat the migration/security sequence.
13. Promote to staging only if every mandatory gate passes.

## Stop conditions

Immediately stop if:

- production data is encountered;
- a production credential is requested for development;
- cross-member data becomes visible;
- anonymous/public access reaches sensitive data;
- role escalation succeeds;
- private documents become publicly accessible;
- audit/payment records can be altered by an unauthorized client;
- migration results differ unexpectedly on clean recreation.

## Current state

The repository-side B.6 execution package is complete. Actual live execution remains blocked solely by the absence of an approved development provider/project connection.

This document is the handoff gate; it does not claim that a provider project has been created or that migrations have been executed.
