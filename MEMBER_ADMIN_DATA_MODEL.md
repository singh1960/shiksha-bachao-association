# Shiksha Bachao Association — Phase A: Member/Admin Data Model & Status System

**Status:** Phase A architecture baseline — not a live database  
**Date:** 23 September 2026  
**Repository:** singh1960/shiksha-bachao-association

## 1. Scope
Phase A fixes the logical data model, identifiers, roles, application statuses and access boundaries before any secure backend is implemented.

**Privacy rule:** No member, applicant, medical, identity or bank data is stored in this repository.

## 2. Identifier System

### Member ID
Format: SBA-M-YYYY-NNNNN
Example: SBA-M-2026-00001
- Unique and permanent.
- Never reuse an old Member ID.
- Do not encode caste, religion, school, health information or other sensitive data.
- Display only to the member and authorized staff.

### Welfare Application Reference
Format: SBA-WF-YYYY-NNNNN
Example: SBA-WF-2026-00001
- Unique per application.
- A member may have multiple applications.
- Reference number is not the Member ID.
- Use the reference number for member-facing application tracking.

### Administrative Decision ID
Format: SBA-DEC-YYYY-NNNNN
### Document Record ID
Format: SBA-DOC-YYYY-NNNNN
Document IDs must not expose the original filename or personal information.

## 3. Member Record
| Field | Required | Access |
|---|---|---|
| Member ID | Yes | Member + authorized staff |
| Full name | Yes | Member + authorized staff |
| Mobile | Yes | Member + authorized staff |
| Email | Optional | Member + authorized staff |
| Address | Yes | Authorized staff; member |
| School / Institution | Yes | Authorized staff; member |
| Designation | Yes | Authorized staff; member |
| Appointment date | Optional | Authorized staff; member |
| Membership date | Yes | Authorized staff; member |
| Membership status | Yes | Member + authorized staff |
| Created / updated timestamps | Yes | Admin/audit |
No public member directory is permitted.

## 4. Membership Status
Controlled values:
1. PENDING — application received, verification pending
2. ACTIVE — membership verified and active
3. SUSPENDED — temporarily restricted by authorized decision
4. EXPIRED — membership period ended where applicable
5. CLOSED — membership record closed
6. REJECTED — membership application not approved
Status changes must be recorded in an audit log with actor, timestamp and reason.

## 5. Welfare Application Record
- Application Reference
- Member ID
- Application date
- Assistance type
- Incident/problem date
- Incident/problem description
- Amount requested
- Estimated total expense
- Self-funded amount
- Other assistance received
- Dependent count, where applicable
- Supporting-document references
- Current status
- Assigned officer/committee
- Decision reference
- Authorization reference
- Closure date
- Created / updated timestamps
The actual personal narrative and documents remain in the secure backend, not in GitHub.

## 6. Welfare Assistance Types
Controlled values aligned with WF-01:
- HEALTH
- ACCIDENT
- EMERGENCY
- DEATH
- DEPENDENT_FAMILY
- SPECIAL_CASE
- OTHER
The public Hindi/English/Marathi form labels remain unchanged.

## 7. Welfare Application Status
Recommended controlled workflow:
1. DRAFT — not yet submitted
2. SUBMITTED — application received
3. ACKNOWLEDGED — reference number issued
4. DOCUMENT_REVIEW — documents being checked
5. ADDITIONAL_DOCUMENTS_REQUIRED — applicant action required
6. ELIGIBILITY_REVIEW — eligibility being checked
7. COMMITTEE_REVIEW — committee consideration
8. APPROVED — assistance approved
9. PARTIALLY_APPROVED — amount approved below amount requested
10. REJECTED — assistance not approved
11. AUTHORIZED — payment/assistance authorization completed
12. PAID_OR_DISBURSED — assistance recorded as disbursed
13. CLOSED — claim closed
14. WITHDRAWN — applicant withdrew the application
15. CANCELLED — application cancelled by authorized administrator

### Status transition rule
A status must not jump directly to a later stage without the required preceding record, except where an authorized administrator performs a documented correction.
Every transition records: previous status; new status; actor ID/role; timestamp; reason/comment; related document/decision ID where applicable.

## 8. Committee Decision
Fields: Decision ID; Application Reference; Meeting/decision date; Decision status; Approved amount; Conditions; Reason/record; Committee members/roles; Supporting resolution/document reference; Created/updated timestamp.
A committee decision is immutable after finalization; corrections require a new audit entry.

## 9. Payment / Assistance Authorization
Fields: Authorization Reference; Application Reference; Approved amount; Authorized date; Authorized by; Disbursement status; Disbursement date; Secure transaction/reference record; Closure linkage.
**Bank account numbers, IFSC and payment credentials must not be stored in public files.**

## 10. Document Record
Only metadata should be referenced by the application system:
- Document ID
- Application Reference
- Document category
- File type
- Upload timestamp
- Verification status
- Verified by
- Verification timestamp
- Secure storage reference
Suggested categories: Membership proof; Identity proof; Medical/hospital document; Accident document; Death certificate; Dependent relationship proof; Other relevant document.

## 11. User Roles
1. Super Administrator — system configuration, user/role administration and authorized oversight.
2. Welfare Committee Member — view assigned applications, review evidence and record committee decisions.
3. Records / Verification Officer — verify membership, documents and application completeness.
4. Finance / Payment Officer — handle approved assistance authorization and disbursement records only.
5. Read-only Auditor — read permitted records and audit logs; no modification rights.
Role assignment must follow least-privilege access.

## 12. Access Matrix
| Resource | Super Admin | Committee | Verification | Finance | Auditor |
|---|---|---|---|---|---|
| Member profile | Full | Read | Update verification fields | Limited | Read |
| Welfare application | Full | Assigned/read | Update review | Approved cases | Read |
| Documents | Full | Read assigned | Verify | No routine access | Read if authorized |
| Committee decision | Full | Create/review | Read | Read | Read |
| Payment record | Full | Read | No | Create/update | Read |
| User/role management | Full | No | No | No | No |
| Audit log | Full | Read | Read | Read | Read |

## 13. Audit Log
Every privileged action should record: Audit ID; timestamp; User ID; role; action; entity type; entity ID; previous value/status where relevant; new value/status where relevant; reason; permitted security/session metadata.
Audit records should be append-only.

## 14. Retention and Privacy Baseline
Before implementation, the organization should formally approve what data is collected; why it is collected; who can access it; how long it is retained; how corrections are handled; how records are securely archived/deleted; and how applicants can raise privacy concerns.
Do not collect a field merely because the system can store it.

## 15. Public Website Boundary
Public GitHub Pages may expose rules, guidance, public forms, survey links, announcements and FAQs.
It must not expose member database, application database, applicant documents, medical information, identity documents, bank details, admin credentials or private audit logs.

## 16. WF-01 Mapping
- Applicant/member details → Member/Application record
- Assistance type → Assistance Type
- Incident/problem → Incident fields
- Financial details → Financial fields
- Supporting documents → Document records
- Declaration → Submission/declaration record
The current three online WF-01 Google Forms remain unchanged by Phase A.

## 17. Phase A Completion Criteria
- identifiers approved;
- statuses approved;
- roles approved;
- core fields approved;
- access boundaries approved;
- retention/privacy rules approved;
- no personal data added to GitHub;
- Phase B can be designed against this stable logical model.

**Change-control rule:** One requirement → one controlled change → one verification → one recorded commit.