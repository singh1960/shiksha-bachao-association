# Phase B.6.6 — Development Execution Handoff & Activation Gate

**Status:** WAITING_FOR_APPROVED_PROVIDER_ACCESS
**Date:** 23 September 2026
**Scope:** Development only
**Production impact:** None

## Purpose

Close the repository-preparation cycle and define the exact handoff required to activate live B.6 execution without exposing credentials or personal data.

## Completed repository-side phases

- B.6.1 — Provider Access & Handoff
- B.6.2 — Provider Project Setup Specification
- B.6.3 — Migration Execution Package
- B.6.4 — Execution Evidence & Gate Register
- B.6.5 — Final Development Security Review

## Activation checklist

Live execution may begin only when every item below is confirmed:

- [ ] Approved development provider selected.
- [ ] Development-only project created.
- [ ] Project is separate from staging and production.
- [ ] Development database is empty/disposable.
- [ ] Development authentication is separate.
- [ ] Development storage is private.
- [ ] No real member/teacher/personal data is present.
- [ ] Secure database access is available to the authorized operator.
- [ ] Backup/snapshot capability is available.
- [ ] Non-secret project/environment identifier is available.

## Safe handoff information

To activate execution, only non-secret information should be communicated:

1. Provider name.
2. Non-secret project/environment identifier.
3. Confirmation: development-only.
4. Confirmation: no production/personal data.
5. Confirmation: approved secure database access is available.

**Never provide in GitHub or ordinary chat:** passwords, API keys, service-role keys, access tokens, database connection strings or private document contents.

## Activation sequence

After the checklist is confirmed:

1. Record the provider/project identifier in the B.6.4 evidence register.
2. Verify development isolation.
3. Execute B.6.3 migration sequence.
4. Run structural validation.
5. Apply and validate RLS/grants.
6. Configure synthetic actors.
7. Run security assertions.
8. Test private dummy-document access.
9. Perform backup/restore.
10. Destroy/recreate and repeat.
11. Populate B.6.4 with observed evidence.
12. Conduct development security sign-off.

## Activation stop conditions

Immediately stop if any of the following occurs:

- production or personal data is detected;
- a production credential is requested or exposed;
- cross-member access succeeds;
- unauthorized privilege escalation succeeds;
- sensitive documents become public;
- protected audit/payment records can be modified by an unauthorized client;
- clean recreation produces unexpected migration differences.

## Current decision

**B.6.6 = WAITING_FOR_APPROVED_PROVIDER_ACCESS**

The repository is prepared for live development execution, but no live provider project, database connection or security-test result is claimed.

**Next operational gate:** approved provider/project access → B.6 live execution → B.6.4 evidence completion → development security sign-off.