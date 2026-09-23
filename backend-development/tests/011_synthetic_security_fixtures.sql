-- Phase B.6 — Synthetic Security Fixtures
-- DEVELOPMENT ONLY. Never run against staging/production.
-- All identifiers below are intentionally synthetic.

begin;

insert into public.roles (name)
values
  ('SUPER_ADMIN'),
  ('WELFARE_COMMITTEE'),
  ('VERIFICATION_OFFICER'),
  ('FINANCE_OFFICER'),
  ('AUDITOR')
on conflict (name) do nothing;

-- Synthetic application/member references are deliberately non-personal.
-- Actual user/member UUIDs should be generated inside the isolated development
-- database; do not paste production identifiers here.

-- Fixture checklist:
-- 1. Create two synthetic members owned by two distinct synthetic users.
-- 2. Create one welfare application for each member.
-- 3. Create one synthetic document owned by each application.
-- 4. Create role assignments for separate test users.
-- 5. Create one approved/authorized workflow case for finance testing.
--
-- These rows are intentionally not auto-created here because auth-linked
-- identifiers must come from the isolated development project's own auth
-- system. This avoids hard-coded UUIDs and prevents accidental reuse of
-- production identities.

commit;

-- Expected post-fixture assertions:
-- A. Member A cannot read/update Member B records.
-- B. A normal member cannot assign an administrative role.
-- C. A normal member cannot modify finalized committee/payment records.
-- D. A private document cannot be read by an unrelated member.
-- E. Audit records cannot be modified by an ordinary client.
-- F. Duplicate financial authorization is rejected by the schema/workflow.
