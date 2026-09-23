# Phase B.6.32 — Service Continuity Assurance, Recovery Testing & Resilience Review

**Status:** BLOCKED_PENDING_B6_31_ACTIVATION
**Date:** 23 September 2026
**Scope:** Recurring service-continuity assurance, backup/restore testing and resilience review
**Production impact:** None

## 1. Purpose

Define the assurance process that follows B.6.31 for verifying that continuity, backup, recovery and resilience controls remain usable over time. This framework does not claim that any live backup, restore test or production recovery exercise has been performed.

## 2. Entry conditions

B.6.32 may be activated only after:

- B.6.30 handover acceptance is complete;
- B.6.31 steady-state operational controls are active;
- approved backup/recovery ownership exists;
- recovery procedures are documented;
- test environments or disposable recovery environments are available where required.

## 3. Assurance cycle

**Plan → Backup Check → Recovery Test → Integrity Verification → Record Evidence → Remediate → Re-test → Approve → Schedule Next Test**

## 4. Backup assurance

Verify, as applicable:

- scheduled backups are executing;
- failures generate appropriate alerts;
- backup retention follows the approved policy;
- backup access is restricted;
- backups are protected from unauthorized modification;
- backup metadata is traceable;
- backup coverage includes required database and document data.

Actual backup coverage must be confirmed against the deployed architecture and must not be assumed from this framework.

## 5. Recovery/restore test

Where authorized, perform recovery testing in an isolated or disposable environment. Verify:

1. recovery point is identified;
2. restoration completes;
3. schema/migration state is consistent;
4. RLS and authorization controls remain intact;
5. private document controls remain intact;
6. welfare workflow data remains consistent;
7. audit records remain usable;
8. application/service functions can be validated;
9. test environment is isolated and disposed of safely after testing.

## 6. Resilience review

Assess single points of failure, dependency risks, provider/service continuity, operational ownership, monitoring coverage, recovery dependencies and rollback capability.

Document assumptions and unresolved resilience risks explicitly.

## 7. Recovery evidence register

| Control | Evidence | Result | Reviewer | Status |
|---|---|---|---|---|
| Backup execution | Backup reference | — | — | PENDING |
| Backup protection | Access/policy reference | — | — | PENDING |
| Restore test | Recovery reference | — | — | PENDING |
| Data integrity | Integrity-check reference | — | — | PENDING |
| RLS/auth | Security-test reference | — | — | PENDING |
| Private documents | Storage-test reference | — | — | PENDING |
| Audit continuity | Audit-check reference | — | — | PENDING |
| Recovery environment cleanup | Cleanup reference | — | — | PENDING |

## 8. Failure handling

A failed mandatory recovery control remains OPEN until remediated and re-tested. If recoverability of required data cannot be demonstrated, escalate to the authorized operational and governance owners and review whether affected service operation should be restricted.

## 9. Test-data protection

Use synthetic or otherwise approved non-production data for recovery testing whenever possible. Do not copy production personal data into development/test environments unless separately authorized and protected under the applicable privacy controls.

## 10. Current result

**B.6.32 = BLOCKED_PENDING_B6_31_ACTIVATION**

No live backup verification, restore test or resilience assessment has been performed by this document.

**Next gate:** activate B.6.31 → execute approved continuity tests → record B.6.32 resilience evidence and remediation.