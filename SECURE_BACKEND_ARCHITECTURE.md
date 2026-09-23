# Shiksha Bachao Association — Phase B: Secure Backend Architecture

**Status:** Architecture baseline — no live backend deployed  
**Date:** 23 September 2026  
**Repository:** singh1960/shiksha-bachao-association

## 1. Purpose

Phase B defines the security-first backend architecture that can later support member accounts, welfare application tracking, document handling and administration.

The existing GitHub Pages website remains public/static. No personal data, credentials, private documents or live database are added to this repository.

## 2. Reference Architecture

Public website (GitHub Pages)
→ secure application/API layer
→ authentication service
→ application database
→ private document/object storage
→ audit-log store

Administrative users access the same secure backend through an authenticated admin interface.

The public website must never connect directly to the database.

## 3. Recommended Logical Components

### A. Authentication
Responsibilities:
- secure sign-in;
- passwordless/OTP or strong password authentication as approved;
- MFA for privileged administrators;
- session/token management;
- account recovery;
- account lock/rate limiting.

Do not build custom password hashing or authentication unless there is a compelling reviewed requirement.

### B. API / Application Layer
Responsibilities:
- validate all input;
- enforce authentication;
- enforce role-based authorization;
- create/update member records;
- create welfare applications;
- enforce status transitions;
- issue reference numbers;
- generate audit events;
- provide only the minimum required data to each client.

All sensitive operations must be server-side.

### C. Database
A relational database is recommended for the structured records defined in Phase A.

Logical entities:
- users
- roles
- user_roles
- members
- membership_status_history
- welfare_applications
- welfare_status_history
- welfare_assistance_types
- documents
- document_verification
- committee_decisions
- payment_authorizations
- audit_logs
- notifications

Use foreign keys, unique constraints, controlled status values and timestamps.

### D. Private Document Storage
Use private object/file storage separate from the database.

Requirements:
- private by default;
- no public bucket/object URLs;
- short-lived signed access URLs where required;
- file-size limits;
- allowlisted file types;
- malware scanning before acceptance where available;
- server-generated storage keys;
- original filenames not used as public identifiers.

### E. Audit Logging
Audit logs should be append-only.

Log:
- actor/user ID;
- role;
- action;
- entity type and ID;
- previous/new status where applicable;
- timestamp;
- reason;
- security/session metadata permitted by the privacy design.

Do not log passwords, authentication secrets, document contents or unnecessary sensitive data.

## 4. Authentication and Authorization

### Member
Member can:
- view own profile;
- submit/track own applications;
- upload requested documents;
- respond to document requests;
- view permitted status information.

Member cannot:
- view another member;
- view another application;
- access admin functions;
- alter committee/payment records.

### Administrator
Access is controlled by the Phase A role matrix.

Enforce authorization on the server for every protected request. UI hiding is not a security control.

## 5. Data Protection

### In transit
- HTTPS/TLS only.
- Redirect HTTP to HTTPS.
- Secure cookies where applicable.
- HSTS after deployment is tested and approved.

### At rest
- Database encryption at rest through the chosen provider.
- Private document storage encryption.
- Encrypted backups.

### Secrets
- No API keys, passwords, tokens or service credentials in GitHub.
- Use environment/secret management provided by the deployment platform.
- Rotate secrets according to a documented policy.
- Separate development, staging and production credentials.

## 6. API Security Baseline

Every protected endpoint should apply:
1. Authentication check.
2. Role/permission check.
3. Input validation.
4. Ownership/scope check.
5. Business-rule validation.
6. Rate limiting where appropriate.
7. Audit event for privileged state changes.

Prevent:
- broken access control;
- IDOR/object-level authorization failures;
- injection;
- unsafe file uploads;
- CSRF where cookie-based authentication is used;
- replay/duplicate submissions;
- excessive data exposure.

## 7. Document Upload Security

WF-01 supporting documents are sensitive.

Required controls:
- authenticated upload;
- server-side file type validation;
- extension/content consistency checks;
- file-size limits;
- malware scanning where available;
- randomized storage keys;
- private storage;
- no executable content;
- controlled download/view authorization;
- audit upload, verification and access events.

## 8. Status Transition Enforcement

The backend must enforce the Phase A workflow.

Example:
SUBMITTED → ACKNOWLEDGED → DOCUMENT_REVIEW → ELIGIBILITY_REVIEW → COMMITTEE_REVIEW → APPROVED/REJECTED → AUTHORIZED → PAID_OR_DISBURSED → CLOSED

Transitions must be validated server-side.

Any exceptional correction requires an authorized role, reason and audit entry.

## 9. Reference Number Generation

Reference numbers must be generated server-side, not by the browser.

Use database uniqueness constraints and a transaction-safe sequence/counter.

Formats remain:
- Member: SBA-M-YYYY-NNNNN
- Welfare: SBA-WF-YYYY-NNNNN
- Decision: SBA-DEC-YYYY-NNNNN
- Document: SBA-DOC-YYYY-NNNNN

## 10. Backup and Recovery

Before production:
- automated database backups;
- encrypted backups;
- document-storage backup/versioning where appropriate;
- tested restore procedure;
- defined recovery objectives;
- access-controlled backup administration.

A backup is not considered valid until a restore test succeeds.

## 11. Monitoring

Monitor:
- authentication failures;
- unusual access patterns;
- privileged changes;
- repeated upload failures;
- application errors;
- storage/database health;
- backup failures.

Alerts must avoid exposing sensitive personal information in notification text.

## 12. Environment Separation

Use at least:
- Development
- Staging
- Production

Production data must not be copied into development without an approved de-identification process.

## 13. Deployment Boundary

The GitHub Pages repository should contain only:
- public website;
- public forms/instructions;
- non-sensitive configuration;
- documentation.

Backend code may live in a separate private repository if the selected architecture requires it.

Never place:
- database credentials;
- private keys;
- production secrets;
- private document URLs;
- member exports;
- application exports

in this public repository.

## 14. Provider Selection Criteria

Before Phase B implementation, select a provider that supports:
- managed authentication;
- relational database or equivalent transactional storage;
- private object storage;
- role-based access;
- auditability;
- backups/recovery;
- HTTPS;
- environment secrets;
- data export;
- deletion/retention controls.

Provider selection is an implementation decision and should be documented separately from this architecture.

## 15. Minimum Production Security Gate

Do not launch the member/admin backend until all are passed:

- authentication tested;
- MFA enabled for privileged users;
- authorization tested by role;
- ownership/access isolation tested;
- input validation tested;
- file upload security tested;
- audit logging tested;
- backups tested with restore;
- secrets removed from source;
- HTTPS/security headers verified;
- error responses checked for data leakage;
- privacy/retention rules approved;
- incident/recovery procedure documented.

## 16. Phase B Deliverables

Architecture deliverables are now defined:

1. Secure authentication design
2. API boundary and endpoint policy
3. Database schema based on Phase A
4. Private document-storage design
5. RBAC policy
6. Audit-log design
7. Backup/recovery plan
8. Security testing checklist
9. Deployment/environment plan
10. Provider decision record

## 17. Current Safe State

No live authentication, database, admin dashboard or private document store has been deployed as part of this phase.

The public website remains unchanged.

**Change-control rule:** One requirement → one controlled change → one verification → one recorded commit.
