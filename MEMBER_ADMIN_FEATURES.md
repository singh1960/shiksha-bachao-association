# Shiksha Bachao Association — Member & Admin Features Foundation

**Status:** Architecture baseline / not a live authentication system  
**Date:** 23 September 2026  
**Repository:** `singh1960/shiksha-bachao-association`

## 1. Purpose

This document defines the controlled next-stage architecture for member and administrative features without weakening the current static GitHub Pages website.

The existing public website remains the source for information, forms and guidance. Member records, welfare claims, administrative decisions and personal documents must not be stored in public HTML/JSON files.

## 2. Member Features

### Member profile
- Member ID / membership number
- Name and contact details
- School / institution
- Designation
- Membership date
- Membership status

### Member services
- Membership application
- Welfare assistance application
- Submission acknowledgement/reference number
- Document submission through a secure external system
- Application status viewing
- Request for correction / additional documents

### Member privacy
- No password, OTP, bank account, IFSC or personal records in public repository files.
- No public member directory.
- No public application-status database.

## 3. Administrative Features

### Admin dashboard
- Secure authentication
- Role-based access
- Member search by membership number
- Application queue
- Document verification status
- Committee decision record
- Payment/assistance authorization record
- Claim closure
- Audit log

### Suggested roles
1. Super Administrator
2. Welfare Committee Member
3. Records / Verification Officer
4. Finance / Payment Officer
5. Read-only Auditor

Each role should receive only the permissions required for its work.

## 4. Welfare Workflow

`WF-01 submission → reference number → document verification → eligibility check → committee decision → assistance authorization → payment record → claim closure`

The existing 30 welfare HTML forms remain unchanged.

## 5. Data Separation

### Public GitHub Pages
Allowed:
- Rules
- Guidance
- Public forms
- Public survey links
- Public announcements
- General FAQs

Not allowed:
- Member database
- Applicant personal information
- Medical documents
- Identity documents
- Bank details
- Payment records
- Admin passwords or tokens

### Secure backend / external system
Required for:
- Authentication
- Personal records
- Application tracking
- Document storage
- Administrative actions
- Audit logs

## 6. Implementation Phases

### Phase A — Foundation
- Define member ID format
- Define application/reference number format
- Define statuses
- Define user roles
- Define data fields
- Define retention/access rules

### Phase B — Secure backend
- Authentication
- Database
- Role-based access
- Secure document storage
- Audit logging

### Phase C — Member portal
- Login
- Profile
- Application submission
- Status tracking
- Document requests
- Notifications

### Phase D — Admin portal
- Member management
- Welfare application queue
- Verification
- Committee decisions
- Authorization and closure
- Reports

### Phase E — Security and release audit
- Access-control testing
- Input validation
- CSRF/session protection
- File-upload restrictions
- Backup/recovery
- Audit-log verification
- Privacy review

## 7. Current Safe State

The current GitHub Pages site remains static and public. No simulated login or fake admin dashboard is being presented as a secure system.

The next implementation should begin only after selecting a secure backend/authentication provider and defining the data model.

## 8. Change-Control Rule

**One requirement → one controlled change → one verification → one recorded commit.**

Any future member/admin implementation must preserve:
- the 30 welfare forms;
- the three-language structure;
- the existing public navigation;
- the current release baseline.
