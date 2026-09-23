# Phase B.6.18 — Production Release Verification & Post-Release Control

**Status:** BLOCKED_PENDING_AUTHORIZED_PRODUCTION_RELEASE
**Date:** 23 September 2026
**Scope:** Production post-release planning only
**Production impact:** None

## Purpose

Define the controlled verification and operational checks that must follow an explicitly authorized production release. This document does not authorize or claim that a production release has occurred.

## Preconditions

Post-release verification may begin only after:

- B.6.16 production-readiness review = PASSED;
- B.6.17 production authorization = APPROVED;
- approved release/version is frozen;
- pre-release backup is confirmed;
- production release evidence is available.

## Immediate verification

After an authorized release, verify:

1. Correct production environment and release version.
2. Database migration completion and expected schema state.
3. RLS and authorization boundaries.
4. Authentication and session behavior.
5. Private document storage access.
6. Welfare workflow/status protections.
7. Audit logging.
8. Monitoring and alerting.
9. Backup availability.
10. Rollback readiness.

## Operational monitoring window

For the approved post-release observation period, review:

- application errors;
- authentication failures;
- authorization denials and unexpected grants;
- database errors;
- storage access anomalies;
- workflow/status anomalies;
- audit-log integrity;
- backup health;
- performance and availability indicators.

Do not collect or retain unnecessary personal information in operational logs.

## Incident and rollback procedure

If a release causes a critical security, privacy, integrity or availability problem:

1. Declare the incident through the approved operational process.
2. Restrict affected functionality where necessary.
3. Preserve relevant non-secret evidence.
4. Protect credentials and sensitive information.
5. Invoke the approved rollback/recovery procedure when authorized.
6. Verify restored security and data integrity.
7. Record root-cause and remediation references.
8. Re-test before any corrective release.

## Post-release evidence

Record only non-secret information:

- release/version reference;
- verification timestamp;
- verification results;
- monitoring summary;
- backup/rollback status;
- incident/remediation references, if any;
- reviewer reference;
- final release verification status.

## Completion criteria

Production release verification may be marked COMPLETE only when all mandatory checks pass and no unresolved critical incident remains.

Completion does not end ongoing operational monitoring or change control.

## Current result

**B.6.18 = BLOCKED_PENDING_AUTHORIZED_PRODUCTION_RELEASE**

No production release or post-release PASS is claimed.

**Next gate:** explicit production authorization and controlled release → execute B.6.18 verification → operational sign-off.