# Phase B.6 — Isolated Development Migration Execution Runbook

**Status:** Execution package prepared; live execution is pending an approved isolated development provider/project.  
**Scope:** Development only; synthetic data only.  
**Production impact:** None.

## 1. Purpose

Phase B.6 converts the Phase B.5 preparation package into a controlled execution procedure for:

1. applying the Phase B.4 PostgreSQL schema;
2. applying grants and RLS policies;
3. loading synthetic fixtures only;
4. running structural validation;
5. running security allow/deny assertions;
6. recording the results;
7. testing reproducibility through clean re-creation.

No production database, production credentials, or real member data may be used.

## 2. Required inputs

Run only after an organizationally approved development environment exists:

- `backend-development/migrations/001_core_schema.sql`
- `backend-development/policies/008_rls_grants.sql`
- `backend-development/tests/009_security_test_fixtures.sql`
- `backend-development/tests/010_migration_validation.sql`
- `backend-development/tests/011_synthetic_security_fixtures.sql`
- `backend-development/.env.example`

The actual development connection values must remain outside Git.

## 3. Execution order

### Step A — Environment gate

Confirm all of the following before connecting:

- [ ] Environment is explicitly development.
- [ ] Project/database is isolated from staging and production.
- [ ] Development credentials are separate.
- [ ] Storage bucket is development-only and private.
- [ ] No real personal data has been imported.
- [ ] Secrets are not present in repository files or command history.
- [ ] Backup/restore capability is available.

If any item fails, stop.

### Step B — Clean schema migration

Execute:

1. `001_core_schema.sql`
2. `010_migration_validation.sql`

Record:

- migration success/failure;
- expected table count;
- foreign-key/constraint results;
- index results;
- any SQL error.

A clean database must pass structural checks before RLS is applied.

### Step C — Grants and RLS

Execute:

`008_rls_grants.sql`

Then rerun `010_migration_validation.sql`.

Required result:

- RLS enabled on every sensitive table;
- no unintended anonymous/public table privileges;
- expected policies present;
- role helper exists with the intended security boundary.

### Step D — Synthetic fixtures

Execute:

`011_synthetic_security_fixtures.sql`

The fixture set must use clearly synthetic identifiers only. It must never contain real names, phone numbers, email addresses, bank details, identity numbers, uploaded documents, or production IDs.

### Step E — Security assertions

Execute:

`009_security_test_fixtures.sql`

Record each assertion as:

- PASS — expected allow/deny behaviour observed;
- FAIL — unexpected behaviour observed;
- BLOCKED — environment/tooling prevented execution.

Blocking failures include:

- cross-member disclosure;
- unauthorized role modification;
- unauthorized protected status transition;
- public document access;
- mutable audit records;
- duplicate financial authorization;
- unexpected anonymous/public access.

### Step F — Reproducibility

Destroy the development database/project only after test evidence is retained outside the database, then recreate it from the version-controlled migration package.

Repeat Steps B–E.

The second run must produce materially equivalent schema, policy and security-test results.

## 4. Evidence record

The execution record should contain:

| Evidence | Required |
|---|---|
| Migration timestamp | Yes |
| Development environment identifier | Yes, non-secret |
| Schema migration result | Yes |
| RLS validation result | Yes |
| Synthetic fixture result | Yes |
| Security assertion result | Yes |
| Private-storage test result | Yes |
| Backup/restore result | Yes |
| Clean re-creation result | Yes |
| Failure/remediation notes | If applicable |

Do not store passwords, API keys, access tokens or private document contents in the evidence record.

## 5. Promotion gate

Phase B.6 is considered **passed** only when all mandatory security assertions pass and the clean re-creation test is successful.

If a mandatory assertion fails, the environment remains development-only. Do not proceed to staging or production.

## 6. Current execution boundary

The repository currently contains the complete development migration, RLS, validation and synthetic-fixture package, but no approved provider project or development database connection has been supplied/configured in this phase. Therefore this repository change records the executable B.6 procedure without falsely claiming that a live migration or security test was run.

**Next gate:** approved isolated development provider access → execute B.6 → record results → remediate any failures → only then consider staging.

## 7. Related files

- `backend-development/DEVELOPMENT_ENVIRONMENT.md`
- `backend-development/migrations/001_core_schema.sql`
- `backend-development/policies/008_rls_grants.sql`
- `backend-development/tests/009_security_test_fixtures.sql`
- `backend-development/tests/010_migration_validation.sql`
- `backend-development/tests/011_synthetic_security_fixtures.sql`
