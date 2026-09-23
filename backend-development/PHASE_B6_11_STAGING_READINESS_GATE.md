# Phase B.6.11 — Staging Readiness Gate

**Status:** BLOCKED_PENDING_DEVELOPMENT_COMPLETION
**Date:** 23 September 2026
**Scope:** Staging planning only
**Production impact:** None

## Purpose

Define the controlled gate that must be satisfied before any staging environment is created or promoted to.

## Hard prerequisite

Staging work must not begin until Phase B.6 development execution is actually completed and signed off. Repository documentation alone is insufficient.

Required prior evidence:

- B.6.4 live evidence register complete;
- B.6.9 development security sign-off complete;
- B.6.10 development completion marked COMPLETE;
- all mandatory security failures remediated and re-tested;
- clean destroy/recreate and reproducibility tests passed.

## Staging isolation requirements

When authorized, staging must be:

- separate from development;
- separate from production;
- free of real member/teacher personal data unless separately approved and protected;
- configured with separate authentication identities;
- configured with private document storage;
- supplied with synthetic or approved non-production data;
- protected by separate credentials and secrets;
- covered by backup/restore procedures;
- covered by audit logging and monitoring.

## Staging security gates

Before staging testing:

1. Verify environment isolation.
2. Apply approved schema migrations through controlled deployment.
3. Apply and validate RLS/grants.
4. Run synthetic authorization and isolation tests.
5. Test private document access.
6. Test workflow/status protections.
7. Test audit and financial controls.
8. Test backup/restore.
9. Record evidence and remediation.
10. Obtain separate staging approval.

## Promotion rule

Development completion does not automatically authorize staging. Staging requires a separate review and explicit organizational approval.

Staging completion does not automatically authorize production.

## No-go conditions

Do not create or promote staging if:

- development has not passed B.6.10;
- provider/project isolation is unclear;
- production data or credentials would be reused improperly;
- required security evidence is missing;
- private documents cannot be isolated;
- backup/restore is unavailable;
- mandatory staging tests fail.

## Current result

**B.6.11 = BLOCKED_PENDING_DEVELOPMENT_COMPLETION**

No staging environment has been created or approved by this document.

**Next gate:** complete B.6.10 after live development execution → separate staging authorization review.