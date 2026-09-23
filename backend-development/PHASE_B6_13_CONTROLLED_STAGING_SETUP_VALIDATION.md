# Phase B.6.13 — Controlled Staging Setup & Validation Package

**Status:** BLOCKED_PENDING_STAGING_AUTHORIZATION
**Date:** 23 September 2026
**Scope:** Staging only
**Production impact:** None

## Purpose

Define the controlled setup and validation sequence to be used only after B.6.12 staging authorization has been explicitly granted.

## Hard prerequisites

Do not create or configure staging until:

- B.6.10 development completion = COMPLETE;
- B.6.9 development security sign-off = COMPLETE;
- B.6.4 development evidence = complete;
- B.6.12 staging authorization = APPROVED;
- no unresolved mandatory development security findings remain.

## Staging isolation

The staging environment must have independent:

- project/environment;
- database;
- authentication identities;
- storage bucket;
- credentials and secrets;
- configuration;
- backup/restore process.

Production credentials and production data must not be copied into staging unless separately approved under documented safeguards.

## Controlled setup sequence

1. Record the non-secret staging environment identifier.
2. Verify separation from development and production.
3. Establish approved staging database and private storage.
4. Apply the approved migration set through the controlled deployment process.
5. Run structural validation.
6. Apply and validate RLS/grants.
7. Configure synthetic or separately approved non-production identities/data.
8. Run member-isolation and role-separation tests.
9. Run workflow/status, audit and financial-control tests.
10. Run private-document access tests.
11. Verify logging and monitoring.
12. Perform backup/restore test.
13. Perform rollback/recovery test.
14. Record all observed evidence and remediation.

## Validation gates

### S13-A — Environment isolation

PASS only when staging cannot unintentionally access development or production resources.

### S13-B — Schema and migration integrity

PASS only when approved migrations and structural checks complete successfully.

### S13-C — RLS and authorization

PASS only when intended access works and unauthorized access is denied.

### S13-D — Data/document privacy

PASS only when non-production data and private documents remain properly isolated.

### S13-E — Workflow and financial integrity

PASS only when protected status, decision, audit and payment controls resist unauthorized operations.

### S13-F — Operational resilience

PASS only when backup/restore, rollback and recovery procedures are successfully tested.

### S13-G — Observability

PASS only when required logs/monitoring are available without exposing secrets or unnecessary personal data.

## Evidence record

For each gate record only non-secret information:

- Evidence ID;
- timestamp/timezone;
- staging environment identifier;
- test/action;
- observed result: PASS / FAIL / BLOCKED;
- observation;
- remediation reference;
- reviewer reference.

## Stop conditions

Immediately stop if:

- production data or credentials are introduced without approval;
- staging can access production unexpectedly;
- unauthorized access succeeds;
- private documents become public;
- protected audit/payment records can be altered improperly;
- backup/restore or rollback fails;
- required evidence is missing.

## Current result

**B.6.13 = BLOCKED_PENDING_STAGING_AUTHORIZATION**

No staging environment has been created, configured or approved by this document.

**Next gate:** B.6.12 approval → execute controlled staging setup → record validation evidence → staging security review.