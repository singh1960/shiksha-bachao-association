# Shiksha Bachao Association — Phase B.2: Provider Selection & Deployment Blueprint

**Status:** Deployment blueprint — no live provider project created
**Date:** 23 September 2026
**Repository:** `singh1960/shiksha-bachao-association`

## 1. Objective
Phase B.2 converts the approved Phase B and B.1 specifications into a provider-selection and deployment plan. It does not create a live database, authentication system or personal-data store.

## 2. Provider Evaluation
Three implementation families were reviewed against the Phase B requirements:

| Capability | Supabase | Firebase | AWS managed services |
|---|---|---|---|
| Relational PostgreSQL model | Native | Not primary | Available via RDS/Aurora |
| Authentication | Supabase Auth | Firebase Authentication | Cognito |
| Private file storage | Supabase Storage | Cloud Storage for Firebase | S3 |
| Fine-grained data authorization | PostgreSQL RLS | Security Rules | IAM + application controls |
| Fit with Phase B relational schema | Direct | Requires model adaptation | Direct but more infrastructure |
| Custom server-side logic | Edge Functions | Cloud Functions/Cloud Run | Lambda/ECS/etc. |

Supabase documentation describes Auth integrated with PostgreSQL and Row Level Security, and its Storage access controls can also use RLS. citeturn0search0turn0search1turn0search9

Firebase provides Authentication plus Security Rules for Firestore and Cloud Storage, including owner/role-based rules and upload validation. citeturn0search2turn0search5turn0search13

AWS can provide the required components as separate managed services, but the deployment would require more explicit service integration and infrastructure decisions.

## 3. Provisional Architecture Target
For this project's current Phase B blueprint, **Supabase is the provisional implementation target**, because the approved schema is relational/PostgreSQL-oriented and Supabase provides integrated Auth, PostgreSQL, Storage and server-side functions.
This is a technical architecture choice, not a claim that Supabase is universally superior. Final provider selection must pass the security, privacy, operational, cost and organizational approval gates below.

Supabase's current security guidance emphasizes grants plus RLS, with service-role credentials kept server-side; its Storage system also supports RLS-based access policies. citeturn0search1turn0search9turn0search16

## 4. Target Mapping
| Phase B.1 requirement | Provisional implementation |
|---|---|
| Authentication | Supabase Auth |
| Users | Auth identity + private application user profile |
| Relational database | PostgreSQL |
| Authorization | PostgreSQL RLS + server-side role checks |
| Private documents | Supabase Storage private bucket |
| Custom workflows | Edge Functions/server-side application layer |
| Audit | append-only application audit table + operational logging |
| Secrets | provider secret/environment management |

## 5. Required Project Separation
Create separate projects/environments for:
1. Development
2. Staging
3. Production

Production credentials must never be reused in development.
Production personal data must never be copied into development unless an approved de-identification process is used.

## 6. Database Deployment Order
1. Create production-independent development project.
2. Apply database migrations from the Phase B.1 schema.
3. Create controlled enums/status constraints.
4. Create indexes and foreign keys.
5. Enable RLS on every exposed sensitive table.
6. Configure grants and RLS policies together.
7. Create role/permission policies.
8. Add audit triggers/functions where appropriate.
9. Run positive and negative authorization tests.
10. Promote the same migration set to staging.
11. Repeat security tests.
12. Production deployment only after approval.

Supabase explicitly recommends enabling RLS and matching grants to the intended operations; its documentation also recommends testing allowed and denied operations. citeturn0search1

## 7. Authentication Deployment
Initial policy:
- Members: approved authentication method after user-experience and privacy review.
- Privileged administrators: MFA mandatory.
- Role assignment is server-controlled.
- No administrator receives privileges merely because they can access the UI.
- Account recovery must use the selected identity provider's secure recovery process.
- Rate limiting/bot protection should be enabled where supported.

## 8. Storage Deployment
Create a private welfare-document bucket.

Rules:
- No public bucket.
- No permanent public document URL.
- Storage path uses generated document/application identifiers, not names.
- Validate file size and type server-side.
- Quarantine/scanning state before availability.
- Only authorized roles can read verified documents.
- Member can access only documents belonging to their own permitted application.
- Document deletion/replacement must be audited.

Supabase Storage supports RLS-based policies and does not allow uploads to buckets without applicable policies by default. citeturn0search9

## 9. API / Server Layer
Sensitive business operations should run through a server-side function/API layer rather than trusting browser logic.
Examples:
- create welfare application;
- generate reference number;
- transition application status;
- finalize committee decision;
- authorize assistance;
- record disbursement;
- issue controlled document access.

Secrets and privileged database credentials remain server-side.

## 10. RLS Policy Model
Minimum policy families:

### Member
- Read own member profile.
- Read own applications.
- Create own permitted application.
- Upload/read own permitted documents.
- Cannot read another member.
- Cannot change protected statuses.

### Verification Officer
- Read assigned/authorized applications.
- Verify documents.
- Record eligibility review.
- Cannot authorize payment unless separately assigned that role.

### Committee
- Read assigned applications.
- Record committee decisions.
- Cannot modify finalized decisions without an audited correction workflow.

### Finance
- Read approved cases necessary for payment.
- Create/update authorization and disbursement records.
- No unnecessary access to medical documents.

### Auditor
- Read permitted records and audit logs.
- No modification rights.

### Super Administrator
- Full authorized administration, subject to audit and separation-of-duty controls.

RLS must be treated as a database security layer, not as a substitute for application-level authorization. Supabase documents grants and RLS as separate access controls. citeturn0search1turn0search16

## 11. Security Gates Before Production
- [ ] Provider terms/privacy review completed.
- [ ] Data retention policy approved.
- [ ] Access/role matrix approved.
- [ ] MFA tested for privileged accounts.
- [ ] RLS positive/negative tests passed.
- [ ] Object-level authorization tests passed.
- [ ] File upload validation tested.
- [ ] Malware scanning/quarantine workflow tested where available.
- [ ] Audit log integrity tested.
- [ ] Backup and restore test passed.
- [ ] Secret-management review passed.
- [ ] HTTPS/security headers verified.
- [ ] Error leakage test passed.
- [ ] Incident/recovery procedure approved.
- [ ] Production environment separately configured.

## 12. Cost and Operational Gate
Before production approval, record:
- expected member count;
- expected annual welfare applications;
- expected document volume and storage growth;
- authentication volume;
- database usage;
- backup requirements;
- expected administrative users;
- provider pricing at the expected usage level;
- export/migration plan.

No production provider contract or paid plan is being created in this phase.

## 13. Data Residency / Legal Review
Before storing real personal or sensitive welfare data, the organization should review the selected provider's current data-processing terms, privacy terms, applicable Indian legal requirements, data-location options, breach/incident obligations and contractual responsibilities.
This document deliberately does not declare legal compliance merely from technical configuration.

## 14. Deployment Structure
Suggested private backend repository structure:

```text
backend/
├── migrations/
├── functions/
├── policies/
├── tests/
├── docs/
├── config/
└── README.md
```

Never commit:
- production secrets;
- service-role keys;
- database passwords;
- private document exports;
- member/application exports;
- production environment files containing secrets.

## 15. Migration Strategy
Use version-controlled migrations.

Migration sequence:
`001_core_roles → 002_members → 003_welfare → 004_documents → 005_decisions → 006_payments → 007_audit → 008_rls → 009_indexes/tests`

Every migration must be reversible where practical or have a documented recovery procedure.

## 16. Rollout Strategy
### Stage 1 — Development
No real personal data. Use synthetic test data only.

### Stage 2 — Security testing
Test every role against both allowed and denied operations.

### Stage 3 — Staging
Use synthetic/de-identified data. Complete backup/restore and file-upload testing.

### Stage 4 — Controlled pilot
Only after organizational approval. Start with a limited administrative group and documented test applications.

### Stage 5 — Production
Enable real member access only after all production gates pass.

## 17. Current Safe State
- GitHub Pages remains unchanged.
- No provider project has been created.
- No authentication credentials have been added.
- No database has been deployed.
- No private storage bucket has been created.
- No personal data has been entered.

## 18. Phase B.2 Completion Criteria
- [x] Provider families evaluated.
- [x] Provisional target selected for blueprint purposes.
- [x] Component mapping defined.
- [x] Environment separation defined.
- [x] Database deployment sequence defined.
- [x] Authentication deployment policy defined.
- [x] Private storage policy defined.
- [x] RLS/access model defined.
- [x] Production security gates defined.
- [x] Cost/operations gate defined.
- [x] Privacy/legal review gate defined.
- [x] Rollout strategy defined.
- [ ] Live provider project — Phase B.3 or later.

**Change-control rule:** One requirement → one controlled change → one verification → one recorded commit.