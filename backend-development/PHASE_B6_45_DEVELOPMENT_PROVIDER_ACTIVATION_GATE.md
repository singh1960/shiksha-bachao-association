# Phase B.6.45 — Development Provider Activation Gate

**Date:** 23 September 2026  
**Status:** PENDING_APPROVED_PROVIDER_ACTIVATION

## 1. Purpose

B.6.45 defines the controlled activation gate for the isolated development provider/project required before the first live development execution.

This gate is preparatory and does not claim that a provider project, database, credentials, migration or security test has been activated.

## 2. Activation Preconditions

Before activation, confirm:
- An approved development provider/project has been selected under organizational authorization.
- The project is separate from staging and production.
- A development-only project identifier is recorded without exposing secrets.
- Development credentials are stored outside Git.
- Production credentials are not present in the development environment.
- The database connection target is confirmed as development.
- Private development storage is configured where required.
- Development authentication is isolated.
- Environment variables contain only approved development values.
- No real personal/member/teacher/application/payment/document data is loaded.

## 3. Required Configuration Boundary

The development environment must use values equivalent to:
- APP_ENV=development
- development API/base URL
- development provider URL
- development database connection
- development storage bucket
- development logging configuration

Real secrets must never be committed to the repository.

## 4. Activation Verification

After configuration, verify:
1. Provider/project identity.
2. Environment identity.
3. Database target.
4. Storage target.
5. Authentication target.
6. Network/API endpoint.
7. Secret separation.
8. Repository configuration contains no credential values.
9. No production resource is referenced.
10. Synthetic-data-only rule is active.

## 5. Mandatory Stop Conditions

Do not activate execution if:
- the provider/project cannot be positively identified;
- the project is shared with production;
- production credentials are detected;
- production database/storage endpoints are referenced;
- real personal data is proposed;
- required authorization is missing;
- secrets would be committed to Git;
- environment separation cannot be demonstrated.

## 6. Evidence Package

The activation evidence record must contain:
- approved provider/project reference;
- environment identifier;
- configuration verification result;
- database-target verification;
- storage-target verification;
- authentication-target verification;
- secret-separation confirmation;
- synthetic-data confirmation;
- activation timestamp;
- responsible operator/approval reference;
- PASS/FAIL decision for each prerequisite.

Secrets themselves must never be recorded in the evidence document.

## 7. Gate Decision

**Current status: PENDING_APPROVED_PROVIDER_ACTIVATION**

The repository is ready for this gate, but the gate cannot be marked PASS until an approved isolated development provider/project is actually available and verified.

## 8. Next Controlled Action

**Activate isolated development environment → verify configuration → record evidence → PASS/FAIL B.6.45 → only then begin B.6 migration execution.**

No migration, RLS test or security execution should be represented as completed before this gate passes.

**Control principle:** Environment first → verification second → execution third.
