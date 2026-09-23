-- Phase B.4 — Development RLS / Grants Policy
-- DEVELOPMENT ONLY. Review against the selected Supabase project before execution.
-- This file intentionally contains no secrets and no real data.

revoke all on all tables in schema public from anon;
revoke all on all tables in schema public from authenticated;

alter table public.users enable row level security;
alter table public.roles enable row level security;
alter table public.user_roles enable row level security;
alter table public.members enable row level security;
alter table public.membership_status_history enable row level security;
alter table public.welfare_applications enable row level security;
alter table public.welfare_status_history enable row level security;
alter table public.documents enable row level security;
alter table public.document_verification enable row level security;
alter table public.committee_decisions enable row level security;
alter table public.committee_decision_members enable row level security;
alter table public.payment_authorizations enable row level security;
alter table public.audit_logs enable row level security;

-- Helper: role membership is resolved from user_roles without granting
-- ordinary users permission to modify their own role assignments.
create or replace function public.has_role(required_role text)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.role_id = ur.role_id
    join public.users u on u.user_id = ur.user_id
    where ur.user_id = auth.uid()
      and r.code = required_role
      and u.account_status = 'ACTIVE'
  );
$$;

revoke execute on function public.has_role(text) from public;
grant execute on function public.has_role(text) to authenticated;

create policy users_self_select on public.users
for select to authenticated
using (user_id = auth.uid() or public.has_role('SUPER_ADMIN'));

create policy roles_select_authenticated on public.roles
for select to authenticated
using (public.has_role('SUPER_ADMIN') or public.has_role('WELFARE_COMMITTEE')
       or public.has_role('VERIFICATION_OFFICER') or public.has_role('FINANCE_OFFICER')
       or public.has_role('AUDITOR'));

create policy user_roles_admin_select on public.user_roles
for select to authenticated
using (public.has_role('SUPER_ADMIN') or public.has_role('AUDITOR'));

create policy members_self_select on public.members
for select to authenticated
using (user_id = auth.uid()
       or public.has_role('SUPER_ADMIN')
       or public.has_role('VERIFICATION_OFFICER')
       or public.has_role('AUDITOR'));

create policy welfare_self_select on public.welfare_applications
for select to authenticated
using (
  member_id in (select m.member_id from public.members m where m.user_id = auth.uid())
  or public.has_role('SUPER_ADMIN')
  or (public.has_role('VERIFICATION_OFFICER') and (assigned_to = auth.uid() or assigned_to is null))
  or public.has_role('WELFARE_COMMITTEE')
  or public.has_role('AUDITOR')
);

create policy welfare_member_insert on public.welfare_applications
for insert to authenticated
with check (
  member_id in (select m.member_id from public.members m where m.user_id = auth.uid())
  and current_status = 'DRAFT'
);

create policy welfare_member_update on public.welfare_applications
for update to authenticated
using (
  member_id in (select m.member_id from public.members m where m.user_id = auth.uid())
  and current_status = 'DRAFT'
)
with check (
  member_id in (select m.member_id from public.members m where m.user_id = auth.uid())
  and current_status = 'DRAFT'
);

create policy welfare_status_history_select on public.welfare_status_history
for select to authenticated
using (
  application_id in (
    select wa.application_id
    from public.welfare_applications wa
    join public.members m on m.member_id = wa.member_id
    where m.user_id = auth.uid()
  )
  or public.has_role('SUPER_ADMIN')
  or public.has_role('VERIFICATION_OFFICER')
  or public.has_role('WELFARE_COMMITTEE')
  or public.has_role('AUDITOR')
);

create policy documents_select_scoped on public.documents
for select to authenticated
using (
  application_id in (
    select wa.application_id
    from public.welfare_applications wa
    join public.members m on m.member_id = wa.member_id
    where m.user_id = auth.uid()
  )
  or public.has_role('SUPER_ADMIN')
  or public.has_role('VERIFICATION_OFFICER')
  or public.has_role('WELFARE_COMMITTEE')
  or public.has_role('AUDITOR')
);

create policy document_verification_select_authorized on public.document_verification
for select to authenticated
using (
  public.has_role('SUPER_ADMIN')
  or public.has_role('VERIFICATION_OFFICER')
  or public.has_role('WELFARE_COMMITTEE')
  or public.has_role('AUDITOR')
);

create policy committee_decisions_select_authorized on public.committee_decisions
for select to authenticated
using (
  public.has_role('SUPER_ADMIN')
  or public.has_role('WELFARE_COMMITTEE')
  or public.has_role('AUDITOR')
);

create policy payment_select_finance_auditor on public.payment_authorizations
for select to authenticated
using (
  public.has_role('SUPER_ADMIN')
  or public.has_role('FINANCE_OFFICER')
  or public.has_role('AUDITOR')
);

create policy audit_select_admin_auditor on public.audit_logs
for select to authenticated
using (public.has_role('SUPER_ADMIN') or public.has_role('AUDITOR'));

-- Deliberately no direct authenticated INSERT/UPDATE/DELETE policies are created
-- for roles, user_roles, audit_logs, finalized decisions, or payment records.
-- Those operations must use reviewed server-side functions/API transactions.
