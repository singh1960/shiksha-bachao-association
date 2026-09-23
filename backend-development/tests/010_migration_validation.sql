-- Phase B.5 — Migration Validation Queries
-- Run only against an isolated DEVELOPMENT database.
-- These queries inspect structure; they do not create real data.

-- 1. Sensitive tables with RLS enabled
select n.nspname as schema_name, c.relname as table_name,
       c.relrowsecurity as rls_enabled
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relname in (
    'users','roles','user_roles','members','membership_status_history',
    'welfare_applications','welfare_status_history','documents',
    'document_verification','committee_decisions',
    'committee_decision_members','payment_authorizations','audit_logs'
  )
order by c.relname;

-- 2. Constraints
select table_name, constraint_name, constraint_type
from information_schema.table_constraints
where table_schema = 'public'
order by table_name, constraint_name;

-- 3. Indexes
select schemaname, tablename, indexname
from pg_indexes
where schemaname = 'public'
order by tablename, indexname;

-- 4. RLS policies
select schemaname, tablename, policyname, permissive, roles, cmd
from pg_policies
where schemaname = 'public'
order by tablename, policyname;

-- 5. Public/anonymous grants
select grantee, table_name, privilege_type
from information_schema.role_table_grants
where table_schema = 'public'
  and grantee in ('anon','public')
order by table_name, grantee, privilege_type;

-- Expected:
-- Every sensitive table: rls_enabled = true.
-- No unintended anon/public table privileges.
-- Expected policies are present.
