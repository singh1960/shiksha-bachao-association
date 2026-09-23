# Shiksha Bachao Association — Phase B.3: Development Database, RLS & Security Test Plan

**Status:** Development-only security specification — no live provider/database deployed  
**Date:** 23 September 2026  
**Repository:** singh1960/shiksha-bachao-association  
**Target architecture:** Supabase/PostgreSQL blueprint, subject to final approval

## 1. Purpose

Phase B.3 converts the Phase B.1 relational design and Phase B.2 provider blueprint into a development-safe database/RLS implementation plan and a repeatable security test matrix.

This phase is **design and test preparation only**. It does not create a Supabase project, database, storage bucket, authentication tenant, API endpoint or production environment.

Only synthetic test identities and fictional records may be used during implementation.

## 2. Non-Negotiable Safety Rules

1. No real member, teacher, applicant, medical, identity, bank or payment data in development.
2. No production credentials, service-role keys or database passwords in GitHub.
3. RLS must be enabled before sensitive tables are exposed through an API/data interface.
4. Database grants and RLS policies must be designed together.
5. Frontend hiding is never an authorization control.
6. Every protected operation requires authentication plus role/object-scope validation.
7. Privileged status changes and financial actions must be auditable.
8. Finalized decisions and audit records must not be silently editable.
9. Development data must be clearly marked synthetic and disposable.
10. Production deployment remains blocked until the security gates in this document pass.

## 3. Development Database Scope

The initial migration set follows the Phase B.2 sequence:

001_core_roles → 002_members → 003_welfare → 004_documents → 005_decisions → 006_payments → 007_audit → 008_rls → 009_indexes_tests

Core tables:

- users
- roles
- user_roles
- members
- membership_status_history
- welfare_applications
- welfare_status_history
- documents
- document_verification
- committee_decisions
- committee_decision_members
- payment_authorizations
- audit_logs

Development-only supporting objects may include:

- helper functions for current-user/role checks;
- status-transition validation functions;
- audit functions/triggers;
- reference-number generators;
- test fixtures;
- test-only views where explicitly approved.

No public view should expose unrestricted sensitive columns.

## 4. Database Constraints

The implementation must enforce, at minimum:

- UUID primary keys.
- Unique member/application/decision/document/payment reference numbers.
- Foreign-key integrity.
- Non-negative monetary amounts.
- dependent_count >= 0.
- Controlled membership, welfare, document and payment statuses.
- Required fields NOT NULL.
- Valid date/timestamp relationships where applicable.
- Unique document storage keys.
- No plaintext passwords.
- Server-side reference generation.
- Transaction-safe status/history updates.
- Protection against duplicate authorization/disbursement.

Database constraints are defense-in-depth; they do not replace server-side authorization.

## 5. Role Model

Approved Phase A roles:

| Role | Intended scope |
|---|---|
| SUPER_ADMIN | Full administrative control subject to audit and separation of duties |
| WELFARE_COMMITTEE | Welfare review and committee decision functions |
| VERIFICATION_OFFICER | Document and eligibility verification |
| FINANCE_OFFICER | Payment authorization/disbursement functions |
| AUDITOR | Read-only permitted audit/review access |

A user may have multiple roles only through an explicit server-controlled role assignment.

## 6. RLS Policy Model

RLS should be enabled on every sensitive table that can be reached through the selected data-access layer.

### 6.1 users

**Allow**
- authenticated user: read only their permitted profile fields;
- privileged administrative access only where operationally necessary.

**Deny**
- member reading another user's account;
- unauthenticated reads;
- member-side writes to roles/account privileges.

### 6.2 roles

**Allow**
- authenticated system functions/admin interfaces to read approved role definitions.

**Deny**
- members assigning themselves roles;
- ordinary users modifying role definitions.

### 6.3 user_roles

**Allow**
- authorized administration/server-side role management.

**Deny**
- self-assignment;
- member modification;
- unauthorized deletion or reassignment.

Role changes must create an audit event.

### 6.4 members

**Allow**
- member: own permitted profile fields;
- verification/admin roles: permitted administrative member records.

**Deny**
- member reading another member;
- member changing protected membership status;
- unauthorized bulk export.

### 6.5 membership_status_history

**Allow**
- authorized administrative read;
- controlled server-side status transition function for inserts.

**Deny**
- member modification;
- arbitrary history deletion/update.

### 6.6 welfare_applications

**Allow**
- member: own permitted application records;
- verification/committee/admin: authorized case scope;
- finance: only the fields/cases necessary for financial processing.

**Deny**
- cross-member access;
- member modification after workflow lock;
- unauthorized direct status changes;
- unrestricted administrative export.

### 6.7 welfare_status_history

**Allow**
- permitted read by case scope;
- inserts only through an authorized status-transition path.

**Deny**
- direct member writes;
- arbitrary update/delete;
- fabricated history entries by unauthorized roles.

### 6.8 documents

**Allow**
- member: documents belonging to their own permitted application;
- verification/committee: only documents required for assigned/authorized review;
- finance: no document access unless explicitly required by policy.

**Deny**
- public access;
- cross-member access;
- predictable/public storage paths;
- unrestricted document listing.

Storage authorization and database authorization must both be enforced.

### 6.9 document_verification

**Allow**
- verification role and authorized administration;
- read access to permitted committee/admin users where needed.

**Deny**
- applicant changing verification status;
- finance changing verification status;
- deletion of verification history.

### 6.10 committee_decisions

**Allow**
- committee/admin to create decisions for authorized applications;
- permitted read access for relevant roles.

**Deny**
- member creating/modifying decisions;
- finance altering committee decisions;
- silent modification after finalization.

Finalization must use a controlled server-side transaction and audit event.

### 6.11 committee_decision_members

**Allow**
- controlled committee/admin management.

**Deny**
- self-adding to a decision;
- member modification;
- unauthorized removal after finalization.

### 6.12 payment_authorizations

**Allow**
- finance/admin for approved cases;
- auditor read access.

**Deny**
- member access to internal authorization fields beyond permitted status information;
- committee direct payment execution;
- duplicate authorization/disbursement;
- unauthorized reversal/cancellation.

### 6.13 audit_logs

**Allow**
- auditor/admin read access according to policy.

**Deny**
- ordinary user access;
- application clients directly updating/deleting audit rows.

Audit creation should occur through controlled server-side logic or protected database functions/triggers.

## 7. Grants and RLS Must Work Together

The implementation sequence is:

1. Create tables.
2. Revoke unnecessary default/public privileges.
3. Grant only required operations to the intended application roles.
4. Enable RLS.
5. Add explicit allow policies.
6. Test allowed operations.
7. Test denied operations.
8. Test object ownership isolation.
9. Test privileged workflows.
10. Record results before any staging promotion.

A policy that appears correct but is reachable through an excessive grant is not considered secure.

## 8. Status Transition Security

The application workflow uses the Phase A statuses:

DRAFT → SUBMITTED → ACKNOWLEDGED → DOCUMENT_REVIEW → ADDITIONAL_DOCUMENTS_REQUIRED / ELIGIBILITY_REVIEW → COMMITTEE_REVIEW → APPROVED / PARTIALLY_APPROVED / REJECTED → AUTHORIZED → PAID_OR_DISBURSED → CLOSED

Exceptional paths include WITHDRAWN and CANCELLED where permitted.

Tests must verify:

- valid transitions succeed;
- invalid transitions fail;
- direct client updates to protected status fail;
- transition + history + audit are atomic;
- reason is captured for privileged/exceptional changes;
- finalized decisions cannot be silently changed;
- duplicate requests do not create duplicate decisions or payments.

## 9. Security Test Matrix

### A. Authentication

| Test | Expected result |
|---|---|
| Unauthenticated read of protected data | DENY |
| Unauthenticated write | DENY |
| Expired/invalid session | DENY |
| Normal member authenticated | Own permitted scope only |
| Privileged admin authenticated with MFA policy | Permitted admin scope |

### B. Object-Level Authorization / IDOR

| Test | Expected result |
|---|---|
| Member reads own application | ALLOW |
| Member reads another member's application ID | DENY / safe NOT_FOUND |
| Member downloads another member's document ID | DENY |
| Member changes another member record | DENY |
| Officer accesses unauthorized case | DENY |
| Finance accesses unrelated medical document | DENY unless explicitly authorized |

### C. Role Separation

| Test | Expected result |
|---|---|
| Verification officer authorizes payment | DENY |
| Finance officer verifies document | DENY |
| Auditor changes application status | DENY |
| Committee directly disburses payment | DENY |
| Member assigns admin role to self | DENY |
| Authorized admin assigns role | ALLOW + audit |

### D. RLS Boundary Tests

For every sensitive table:

1. test no-session access;
2. test member own-row access;
3. test member cross-row access;
4. test each privileged role's intended scope;
5. test a role outside the table's business scope;
6. test insert;
7. test update;
8. test delete;
9. test bulk query;
10. test filtered query attempting to bypass ownership.

Expected result: only explicitly permitted operations succeed.

### E. Document Security

- Public object URL access: DENY.
- Wrong application document ID: DENY.
- Unauthenticated download: DENY.
- Unauthorized role download: DENY.
- Allowed member download of own permitted document: ALLOW.
- Allowed verifier access: ALLOW.
- Oversized file: DENY.
- Disallowed extension/content type: DENY.
- Malicious/quarantined file: not made AVAILABLE.
- Replacement/deletion: authorization + audit required.
- Storage key containing a person's name: FAIL validation; generated key required.

### F. Audit Integrity

- Protected state change creates audit event.
- Actor, action, entity and timestamp are present.
- Previous/new state are captured where applicable.
- Member cannot update/delete audit records.
- Auditor cannot alter audit records.
- Audit records contain no passwords, tokens or document contents.
- Repeated request does not create misleading duplicate state changes.

### G. Idempotency and Concurrency

- Same idempotency key submitted twice → one effective operation.
- Concurrent application creation → unique references remain unique.
- Concurrent status transitions → one valid transition wins; conflicting request receives safe conflict response.
- Concurrent payment authorization → no double authorization.
- Concurrent disbursement → no double disbursement.
- Optimistic-lock/version conflict is detected where editing requires it.

### H. Input / Data Validation

Test:

- negative monetary values;
- excessive monetary precision;
- negative dependent count;
- invalid status values;
- invalid assistance type;
- malformed UUID/reference;
- oversized text;
- unexpected JSON fields;
- invalid dates;
- duplicate reference numbers;
- SQL/injection-style input;
- HTML/script payloads where displayed;
- invalid file MIME/extension combinations.

Expected result: safe validation failure without SQL errors, stack traces or sensitive data leakage.

## 10. Privacy and Data-Leakage Tests

The test suite must check that:

- API responses contain only required fields;
- another member's address/mobile/email cannot be inferred from list endpoints;
- sensitive welfare descriptions are not returned to unauthorized roles;
- document contents are never embedded in ordinary application-list responses;
- error messages do not reveal whether unauthorized private records exist unless policy explicitly permits it;
- logs do not contain passwords, tokens, full identity documents or unnecessary sensitive details.

## 11. Backup / Recovery Test Preparation

Before production:

1. Create synthetic development backup.
2. Restore into an isolated test environment.
3. Verify schema, constraints, RLS and indexes.
4. Verify synthetic records.
5. Verify private-document references without exposing public URLs.
6. Record restore duration and result.
7. Document recovery procedure.
8. Repeat in staging before production approval.

A backup is not accepted as valid until a restore test succeeds.

## 12. Synthetic Test Dataset

Use clearly fictional values such as:

- Test Member A
- Test Member B
- test.member.a@example.invalid
- test.member.b@example.invalid
- fictional application/reference numbers generated by the test environment.

Never use real names, phone numbers, Aadhaar/PAN details, medical records, bank details, school employee records or real welfare documents.

All fixture files should be harmless dummy files and must never contain personal data.

## 13. Test Automation Structure

When implementation begins in a private backend repository, use a structure similar to:

~~~
backend/
├── migrations/
├── functions/
├── policies/
├── tests/
│   ├── auth/
│   ├── rls/
│   ├── ownership/
│   ├── workflow/
│   ├── documents/
│   ├── audit/
│   ├── concurrency/
│   └── validation/
├── fixtures/
├── docs/
└── README.md
~~~

Tests should run against an isolated development database and synthetic fixtures.

## 14. Pass/Fail Rules

A security test suite is **PASS** only when:

- all mandatory deny tests deny;
- all required allow tests allow;
- no cross-member data leakage is observed;
- no privilege escalation is possible through direct data operations;
- protected status transitions are server-controlled;
- document access is private and scoped;
- audit records are protected;
- idempotency/concurrency controls prevent duplicate financial actions;
- validation tests produce safe errors;
- no secrets appear in source, logs or test fixtures.

Any critical authorization failure is an automatic **FAIL** and blocks staging/production promotion.

## 15. Production Gate

Before real personal data is introduced, obtain documented approval for:

- provider and contractual/privacy review;
- final role matrix;
- authentication and privileged MFA;
- RLS/grants test results;
- object-level authorization results;
- document upload/security results;
- audit integrity results;
- backup/restore results;
- incident/recovery procedure;
- retention/deletion rules;
- data migration/de-identification procedure;
- production secret-management configuration.

## 16. Phase B.3 Completion Checklist

- [x] Development-only scope defined.
- [x] Migration sequence mapped.
- [x] Sensitive tables identified.
- [x] Role/RLS model defined.
- [x] Grants + RLS sequencing defined.
- [x] Ownership/isolation tests defined.
- [x] Role-separation tests defined.
- [x] Status-transition tests defined.
- [x] Document-security tests defined.
- [x] Audit-integrity tests defined.
- [x] Idempotency/concurrency tests defined.
- [x] Validation and data-leakage tests defined.
- [x] Synthetic-data policy defined.
- [x] Production gate defined.
- [ ] Live database/provider deployment — later phase.
- [ ] Real personal data — prohibited until all gates pass.

**Current safe state:** Documentation and test design complete; no live backend, provider project or personal data has been deployed.

**Change-control rule:** One requirement → one controlled change → one verification → one recorded commit.
