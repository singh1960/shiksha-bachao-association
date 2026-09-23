# Phase B.6.8 — Development Provider Activation Checklist

**Status:** PENDING_APPROVED_PROVIDER_ACTIVATION
**Date:** 23 September 2026
**Scope:** Development only
**Production impact:** None

## Purpose

Provide the final controlled checklist to activate the already-prepared B.6 development execution workflow when an approved provider project becomes available.

## Activation record

Complete only with non-secret information:

- Provider: `<provider name>`
- Project/environment identifier: `<non-secret identifier>`
- Environment: `development`
- Isolation from staging/production: `CONFIRMED / NOT CONFIRMED`
- Real personal/member data present: `NO / YES`
- Secure database access available: `YES / NO`
- Private development storage ready: `YES / NO`
- Backup/snapshot ready: `YES / NO`
- Authorized operator: `<reference only>`

## Pre-execution gate

All items must be CONFIRMED before running any migration:

- [ ] Provider/project is approved for development.
- [ ] Project is isolated from staging and production.
- [ ] Database is empty or disposable.
- [ ] Authentication is development-only.
- [ ] Storage is private.
- [ ] No real personal/member data is present.
- [ ] Secure database access is available.
- [ ] Backup/snapshot capability is available.
- [ ] Credentials remain outside Git and ordinary chat.

If any item is not confirmed, status remains `BLOCKED`.

## Controlled activation sequence

1. Record the non-secret activation record.
2. Reconfirm the pre-execution gate.
3. Execute `001_core_schema.sql`.
4. Run `010_migration_validation.sql`.
5. Execute `008_rls_grants.sql`.
6. Run `010_migration_validation.sql` again.
7. Configure synthetic authentication actors.
8. Execute `011_synthetic_security_fixtures.sql`.
9. Execute `009_security_test_fixtures.sql`.
10. Test private dummy-document access.
11. Create a backup/snapshot.
12. Restore to a clean disposable environment.
13. Repeat the migration and security sequence.
14. Record observed results in B.6.4.
15. Conduct final development security sign-off.

## Evidence rule

Do not mark a control PASS because a script exists. PASS requires an observed result from the approved development environment. Unexecuted controls remain `BLOCKED` or `PENDING`.

## Immediate stop conditions

Stop execution immediately if:

- production data or credentials are encountered;
- personal/member data appears in development;
- anonymous access reaches sensitive data;
- cross-member access succeeds;
- unauthorized role escalation succeeds;
- private documents become public;
- audit/payment records can be changed by an unauthorized client;
- backup/restore is unreliable;
- clean recreation produces unexpected schema/policy differences.

## Current result

**B.6.8 = PENDING_APPROVED_PROVIDER_ACTIVATION**

No provider project, database connection, migration execution or live security PASS is claimed by this document.

**Next gate:** approved provider activation record → execute B.6.3 → populate B.6.4 → B.6.9 development security sign-off.