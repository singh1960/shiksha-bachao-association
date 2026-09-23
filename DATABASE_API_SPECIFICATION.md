# Shiksha Bachao Association — Phase B.1: Database Schema & API Specification

**Status:** Design specification — no live database/API deployed  
**Date:** 23 September 2026  
**Repository:** singh1960/shiksha-bachao-association

## 1. Purpose
Phase B.1 converts the approved Phase A data model into a provider-neutral relational schema and secure API contract.
This is a specification only. It contains no real member, applicant, document or payment data.

## 2. Design Principles
- Least privilege.
- Server-side authorization on every protected request.
- Database constraints reinforce application rules.
- Personal and sensitive data stays outside the public GitHub repository.
- Reference numbers are generated server-side.
- Status transitions are validated server-side.
- Audit records are append-only.
- APIs return minimum necessary data.
- UTC timestamps should be stored consistently.

## 3. Relational Schema

### Core entities
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

### Key tables
**users:** user_id UUID PK; auth_provider_subject UNIQUE; email; account_status; created_at; updated_at; last_login_at. Never store plaintext passwords.

**roles:** role_id UUID PK; code UNIQUE; name. Initial roles: SUPER_ADMIN, WELFARE_COMMITTEE, VERIFICATION_OFFICER, FINANCE_OFFICER, AUDITOR.

**user_roles:** user_id FK users; role_id FK roles; assigned_at; assigned_by FK users. Primary key is (user_id, role_id).

**members:** member_id UUID PK; member_number VARCHAR(32) UNIQUE; full_name; mobile; email; address; school_institution; designation; appointment_date; membership_date; membership_status; created_at; updated_at.

**membership_status_history:** history_id UUID PK; member_id FK; previous_status; new_status; changed_by FK users; reason; changed_at.

**welfare_applications:** application_id UUID PK; application_number VARCHAR(32) UNIQUE; member_id FK; application_date; assistance_type; incident_date; incident_description; amount_requested DECIMAL(12,2); estimated_total_expense DECIMAL(12,2); self_funded_amount; other_assistance_received; other_assistance_details; dependent_count; current_status; assigned_to FK users; created_at; updated_at; closed_at.

**welfare_status_history:** history_id UUID PK; application_id FK; previous_status; new_status; changed_by FK users; reason; related_document_id; changed_at.

**documents:** document_id UUID PK; document_number VARCHAR(32) UNIQUE; application_id FK; category; storage_key UNIQUE; original_filename private metadata; mime_type; size_bytes; upload_status; uploaded_by FK users; uploaded_at. Storage keys must not contain personal information.

**document_verification:** verification_id UUID PK; document_id FK; status; verified_by FK users; verification_notes; verified_at.

**committee_decisions:** decision_id UUID PK; decision_number VARCHAR(32) UNIQUE; application_id FK; decision_date; decision_status; approved_amount; conditions; reason; resolution_reference; finalized_at; created_at.

**committee_decision_members:** decision_id FK; user_id FK; role_at_decision. Primary key is (decision_id, user_id).

**payment_authorizations:** authorization_id UUID PK; authorization_number VARCHAR(32) UNIQUE; application_id FK; approved_amount; authorized_by FK users; authorized_at; disbursement_status; disbursement_date; secure_transaction_reference; created_at.

**audit_logs:** audit_id UUID PK; actor_user_id FK users; action; entity_type; entity_id; previous_value JSONB; new_value JSONB; reason; created_at. Audit records are append-only and must not contain secrets or full document contents.

## 4. Controlled Values
Membership: PENDING, ACTIVE, SUSPENDED, EXPIRED, CLOSED, REJECTED.

Assistance: HEALTH, ACCIDENT, EMERGENCY, DEATH, DEPENDENT_FAMILY, SPECIAL_CASE, OTHER.

Welfare status: DRAFT, SUBMITTED, ACKNOWLEDGED, DOCUMENT_REVIEW, ADDITIONAL_DOCUMENTS_REQUIRED, ELIGIBILITY_REVIEW, COMMITTEE_REVIEW, APPROVED, PARTIALLY_APPROVED, REJECTED, AUTHORIZED, PAID_OR_DISBURSED, CLOSED, WITHDRAWN, CANCELLED.

Document verification: PENDING, VERIFIED, REJECTED, REPLACEMENT_REQUIRED.

Document upload: UPLOADING, QUARANTINED, SCANNING, AVAILABLE, REJECTED, DELETED.

Payment/disbursement: PENDING, AUTHORIZED, PROCESSING, DISBURSED, FAILED, REVERSED, CANCELLED.

## 5. Required Database Constraints
- Unique member, application, decision, document and authorization numbers.
- Foreign-key integrity.
- Non-negative monetary amounts.
- Dependent count >= 0.
- Controlled status values.
- Required fields NOT NULL.
- Finalized committee decisions immutable through service-layer rules.
- Transaction-safe reference generation.
- Index foreign keys and frequently queried reference/status fields.

## 6. API Design
Base path: /api/v1

### Member APIs
| Method | Endpoint | Purpose | Access |
|---|---|---|---|
| GET | /me | Current authenticated profile | Member |
| GET | /me/applications | Own applications | Member |
| GET | /applications/{id} | Own application | Member; authorized staff |
| POST | /applications | Create/submit application | Member |
| PATCH | /applications/{id} | Update allowed fields before lock | Member; authorized staff |
| POST | /applications/{id}/documents | Upload document | Member; authorized staff |
| GET | /applications/{id}/documents | List permitted documents | Owner/authorized staff |
| GET | /applications/{id}/status | Current permitted status | Owner/authorized staff |

### Verification APIs
| Method | Endpoint | Purpose | Access |
|---|---|---|---|
| GET | /admin/applications | Filtered queue | Verification/Committee/Admin |
| PATCH | /admin/applications/{id}/assign | Assign officer | Admin |
| POST | /admin/documents/{id}/verify | Verify/reject document | Verification |
| POST | /admin/applications/{id}/request-documents | Request documents | Verification/Committee/Admin |
| POST | /admin/applications/{id}/eligibility | Record eligibility review | Verification |

### Committee APIs
| Method | Endpoint | Purpose | Access |
|---|---|---|---|
| GET | /committee/applications/{id} | Assigned review | Committee/Admin |
| POST | /committee/applications/{id}/decision | Create decision | Committee/Admin |
| POST | /committee/decisions/{id}/finalize | Finalize decision | Authorized Committee/Admin |

### Finance APIs
| Method | Endpoint | Purpose | Access |
|---|---|---|---|
| GET | /finance/applications | Approved cases | Finance/Admin |
| POST | /finance/applications/{id}/authorize | Authorize assistance | Finance/Admin |
| POST | /finance/authorizations/{id}/disburse | Record disbursement | Finance/Admin |

### Administration APIs
| Method | Endpoint | Purpose | Access |
|---|---|---|---|
| GET | /admin/members | Search members | Admin/Verification |
| GET | /admin/members/{id} | Permitted member record | Admin/Verification |
| PATCH | /admin/members/{id}/status | Change membership status | Admin |
| GET | /admin/audit-logs | Audit review | Admin/Auditor |

## 7. API Security Rules
Every protected endpoint must perform authentication, role/permission check, object ownership/scope check, input/schema validation, business-rule validation, rate limiting where appropriate, and an audit event for privileged state changes.
Never rely on hidden buttons or frontend checks for authorization.

## 8. Error Contract
Use a consistent safe error structure with code, safe message and server-generated request_id.
Suggested codes: UNAUTHENTICATED, FORBIDDEN, NOT_FOUND, VALIDATION_ERROR, INVALID_STATUS_TRANSITION, DOCUMENT_REJECTED, RATE_LIMITED, CONFLICT, INTERNAL_ERROR.
Do not return stack traces, SQL errors, secrets or private records.

## 9. Idempotency and Concurrency
- Support idempotency keys for actions that could create duplicate records.
- Use database transactions.
- Use optimistic locking/version numbers where concurrent editing is possible.
- Prevent double authorization or disbursement.

## 10. Pagination and Filtering
Administrative lists must use server-side pagination. Never return the entire database.
Controlled filters may include application number, member number, status, assistance type, assigned officer and date range. Sensitive free-text search should be restricted and audited.

## 11. Private File Download
Use an authorization-checked endpoint such as GET /documents/{id}/download. The backend may issue a short-lived signed URL only after authorization.

## 12. Status Transition API
POST /admin/applications/{id}/status-transition
Request fields: target status, reason, optional related document/decision ID, and idempotency key where appropriate.
The server validates current and target status, then writes status history and current status in one transaction.

## 13. Transaction Boundaries
At minimum: application creation + initial status + reference; status change + history + audit; committee finalization + decision + audit; payment authorization + audit; disbursement + audit; document verification + verification record + audit.

## 14. API Versioning
Current contract: /api/v1. Breaking changes require a new version such as /api/v2. Non-breaking additions must remain backward-compatible.

## 15. Privacy Minimization
APIs must not expose another member's personal data, unnecessary medical details, unauthorized identity-document contents, bank data to roles without need, authentication secrets or unnecessary internal security metadata.

## 16. Phase B.1 Completion Checklist
- [x] Provider-neutral relational entities defined.
- [x] Phase A identifiers mapped.
- [x] Controlled status values defined.
- [x] Role/access boundaries mapped.
- [x] Core API endpoints specified.
- [x] Security rules specified.
- [x] Error contract specified.
- [x] Idempotency/concurrency rules specified.
- [x] Private file-download security specified.
- [x] Transaction boundaries specified.
- [x] API versioning specified.
- [x] Privacy minimization specified.
- [ ] Actual provider/database deployment — Phase B.2 or later.
- [ ] Live API implementation — Phase B.2 or later.

**Current state:** Design complete; no live personal-data system deployed.

**Change-control rule:** One requirement → one controlled change → one verification → one recorded commit.