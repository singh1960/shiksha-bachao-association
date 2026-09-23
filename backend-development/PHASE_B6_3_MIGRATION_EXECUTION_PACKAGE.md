# Phase B.6.3 — Development Migration Execution Package

**Status:** Prepared — execution gated by approved development provider access
**Scope:** Development only
**Production impact:** None

## Objective

Provide the controlled execution sequence for the approved development database after the B.6.2 provider-project readiness gate passes.

## Preconditions

All B.6.2 gates must be PASS before execution begins:

- isolated development project;
- empty/disposable development database;
- separate development authentication;
- private development storage;
- no production or personal data;
- credentials outside Git and ordinary chat;
- backup/snapshot capability available;
- approved secure database access.

## Execution sequence

Execute exactly in this order:

1. `backend-development/migrations/001_core_schema.sql`
2. `backend-development/tests/010_migration_validation.sql`
3. `backend-development/policies/008_rls_grants.sql`
4. `backend-development/tests/010_migration_validation.sql` again
5. Configure synthetic development authentication actors
6. `backend-development/tests/011_synthetic_security_fixtures.sql`
7. `backend-development/tests/009_security_test_fixtures.sql`
8. Execute private dummy-document access checks
9. Create a development backup/snapshot
10. Restore into a clean disposable development environment
11. Repeat steps 1–8 on the clean environment
12. Compare the two execution results

## Validation gates

### Gate A — Schema

PASS only when required tables, primary/foreign keys, checks, unique constraints and indexes are present and the migration completes without unexpected errors.

### Gate B — RLS and grants

PASS only when RLS is enabled on all designated sensitive tables, intended policies exist, and anonymous/authenticated clients do not receive unintended table privileges.

### Gate C — Identity isolation

PASS only when synthetic member A cannot read or modify member B's records and member B cannot read or modify member A's records.

### Gate D — Role separation

PASS only when verification, committee, finance, auditor and super-admin permissions remain within their defined responsibilities and ordinary member identities cannot escalate privileges.

### Gate E — Workflow integrity

PASS only when protected status transitions cannot be bypassed by an unauthorized client and finalized decision/payment records cannot be directly modified by an ordinary authenticated client.

### Gate F — Document security

PASS only when development welfare documents remain private and unauthorized identities cannot obtain another member's document.

### Gate G — Audit integrity

PASS only when ordinary clients cannot directly rewrite or delete audit records.

### Gate H — Reproducibility

PASS only when a clean disposable environment can reproduce the same schema, RLS and security-test outcome.

## Evidence requirements

Record for each gate:

- timestamp;
- development environment identifier (non-secret only);
- migration/script name;
- result: PASS / FAIL / BLOCKED;
- concise observation;
- remediation reference if failed;
- operator/reviewer reference without exposing credentials or personal data.

Never record passwords, API keys, access tokens, service-role keys or database connection strings.

## Failure handling

If any mandatory gate fails:

1. Stop promotion.
2. Record the failure without secrets or personal data.
3. Identify the affected migration/policy/test.
4. Correct the repository artifact or development configuration through one controlled change.
5. Re-run from the affected gate on a clean disposable environment where required.
6. Update the evidence record.

## Promotion rule

Development PASS does not itself authorize production deployment. Staging requires separate approval and environment validation. Production requires its own security, privacy, legal, operational and organizational approvals.

## Current execution boundary

This package is prepared and repository-side verified. It does **not** claim that a provider project exists, that migrations have been executed, or that any security gate has passed live.

**Next gate:** approved development provider connection + B.6.2 readiness PASS → execute and record B.6.3 evidence.