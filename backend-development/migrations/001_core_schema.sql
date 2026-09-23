-- Phase B.4 — Development SQL Schema
-- DEVELOPMENT ONLY. No production data. No credentials.
-- Target: PostgreSQL/Supabase-compatible design.
-- Apply only in an isolated development project after review.

create extension if not exists pgcrypto;

create table if not exists public.roles (
  role_id uuid primary key default gen_random_uuid(),
  code text unique not null check (code in (
    'SUPER_ADMIN','WELFARE_COMMITTEE','VERIFICATION_OFFICER','FINANCE_OFFICER','AUDITOR'
  )),
  name text not null
);

create table if not exists public.users (
  user_id uuid primary key,
  auth_provider_subject uuid unique not null,
  email text,
  account_status text not null default 'ACTIVE'
    check (account_status in ('PENDING','ACTIVE','SUSPENDED','CLOSED')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  last_login_at timestamptz
);

create table if not exists public.user_roles (
  user_id uuid not null references public.users(user_id) on delete restrict,
  role_id uuid not null references public.roles(role_id) on delete restrict,
  assigned_at timestamptz not null default now(),
  assigned_by uuid references public.users(user_id),
  primary key (user_id, role_id)
);

create table if not exists public.members (
  member_id uuid primary key default gen_random_uuid(),
  member_number varchar(32) unique not null,
  user_id uuid unique references public.users(user_id) on delete set null,
  full_name text not null,
  mobile text,
  email text,
  address text,
  school_institution text,
  designation text,
  appointment_date date,
  membership_date date,
  membership_status text not null default 'PENDING'
    check (membership_status in ('PENDING','ACTIVE','SUSPENDED','EXPIRED','CLOSED','REJECTED')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.membership_status_history (
  history_id uuid primary key default gen_random_uuid(),
  member_id uuid not null references public.members(member_id) on delete restrict,
  previous_status text,
  new_status text not null,
  changed_by uuid references public.users(user_id),
  reason text,
  changed_at timestamptz not null default now()
);

create table if not exists public.welfare_applications (
  application_id uuid primary key default gen_random_uuid(),
  application_number varchar(32) unique not null,
  member_id uuid not null references public.members(member_id) on delete restrict,
  application_date date not null default current_date,
  assistance_type text not null
    check (assistance_type in ('HEALTH','ACCIDENT','EMERGENCY','DEATH','DEPENDENT_FAMILY','SPECIAL_CASE','OTHER')),
  incident_date date,
  incident_description text,
  amount_requested numeric(12,2) not null default 0 check (amount_requested >= 0),
  estimated_total_expense numeric(12,2) not null default 0 check (estimated_total_expense >= 0),
  self_funded_amount numeric(12,2) not null default 0 check (self_funded_amount >= 0),
  other_assistance_received boolean not null default false,
  other_assistance_details text,
  dependent_count integer not null default 0 check (dependent_count >= 0),
  current_status text not null default 'DRAFT'
    check (current_status in ('DRAFT','SUBMITTED','ACKNOWLEDGED','DOCUMENT_REVIEW',
    'ADDITIONAL_DOCUMENTS_REQUIRED','ELIGIBILITY_REVIEW','COMMITTEE_REVIEW',
    'APPROVED','PARTIALLY_APPROVED','REJECTED','AUTHORIZED','PAID_OR_DISBURSED',
    'CLOSED','WITHDRAWN','CANCELLED')),
  assigned_to uuid references public.users(user_id),
  version_no integer not null default 1 check (version_no > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  closed_at timestamptz
);

create table if not exists public.welfare_status_history (
  history_id uuid primary key default gen_random_uuid(),
  application_id uuid not null references public.welfare_applications(application_id) on delete restrict,
  previous_status text,
  new_status text not null,
  changed_by uuid references public.users(user_id),
  reason text,
  related_document_id uuid,
  changed_at timestamptz not null default now()
);

create table if not exists public.documents (
  document_id uuid primary key default gen_random_uuid(),
  document_number varchar(32) unique not null,
  application_id uuid not null references public.welfare_applications(application_id) on delete restrict,
  category text not null,
  storage_key text unique not null,
  original_filename text,
  mime_type text,
  size_bytes bigint check (size_bytes >= 0),
  upload_status text not null default 'UPLOADING'
    check (upload_status in ('UPLOADING','QUARANTINED','SCANNING','AVAILABLE','REJECTED','DELETED')),
  uploaded_by uuid references public.users(user_id),
  uploaded_at timestamptz not null default now()
);

create table if not exists public.document_verification (
  verification_id uuid primary key default gen_random_uuid(),
  document_id uuid not null references public.documents(document_id) on delete restrict,
  status text not null default 'PENDING'
    check (status in ('PENDING','VERIFIED','REJECTED','REPLACEMENT_REQUIRED')),
  verified_by uuid references public.users(user_id),
  verification_notes text,
  verified_at timestamptz
);

alter table public.welfare_status_history
  add constraint welfare_status_history_document_fk
  foreign key (related_document_id) references public.documents(document_id) on delete restrict;

create table if not exists public.committee_decisions (
  decision_id uuid primary key default gen_random_uuid(),
  decision_number varchar(32) unique not null,
  application_id uuid not null references public.welfare_applications(application_id) on delete restrict,
  decision_date date not null default current_date,
  decision_status text not null check (decision_status in ('DRAFT','FINAL','REVOKED')),
  approved_amount numeric(12,2) not null default 0 check (approved_amount >= 0),
  conditions text,
  reason text,
  resolution_reference text,
  finalized_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists public.committee_decision_members (
  decision_id uuid not null references public.committee_decisions(decision_id) on delete restrict,
  user_id uuid not null references public.users(user_id) on delete restrict,
  role_at_decision text not null,
  primary key (decision_id, user_id)
);

create table if not exists public.payment_authorizations (
  authorization_id uuid primary key default gen_random_uuid(),
  authorization_number varchar(32) unique not null,
  application_id uuid not null references public.welfare_applications(application_id) on delete restrict,
  approved_amount numeric(12,2) not null check (approved_amount >= 0),
  authorized_by uuid references public.users(user_id),
  authorized_at timestamptz,
  disbursement_status text not null default 'PENDING'
    check (disbursement_status in ('PENDING','AUTHORIZED','PROCESSING','DISBURSED','FAILED','REVERSED','CANCELLED')),
  disbursement_date date,
  secure_transaction_reference text,
  created_at timestamptz not null default now()
);

create table if not exists public.audit_logs (
  audit_id uuid primary key default gen_random_uuid(),
  actor_user_id uuid references public.users(user_id),
  action text not null,
  entity_type text not null,
  entity_id uuid,
  previous_value jsonb,
  new_value jsonb,
  reason text,
  created_at timestamptz not null default now()
);

create index if not exists idx_members_user_id on public.members(user_id);
create index if not exists idx_members_status on public.members(membership_status);
create index if not exists idx_welfare_member on public.welfare_applications(member_id);
create index if not exists idx_welfare_status on public.welfare_applications(current_status);
create index if not exists idx_welfare_assigned on public.welfare_applications(assigned_to);
create index if not exists idx_documents_application on public.documents(application_id);
create index if not exists idx_audit_entity on public.audit_logs(entity_type, entity_id);
create index if not exists idx_audit_actor on public.audit_logs(actor_user_id);

-- No seed data is included in this migration.
