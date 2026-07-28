-- Spendly — Supabase schema
-- Run this once in your project's SQL Editor (Supabase Dashboard → SQL Editor).
-- Safe to re-run: every statement is guarded with IF NOT EXISTS / OR REPLACE.

-- ============================================================
-- profiles — one row per auth.users, holds the display name shown
-- on Dashboard/Profile ("Xin chào 👋 / Minh Anh"). Register only collects
-- email/password, so full_name defaults to the email's local-part via the
-- trigger below; users can rename themselves later from Settings.
-- ============================================================
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text not null,
  email text not null,
  created_at timestamptz not null default now()
);

-- Screen 12b (Edit Profile) collects Họ/Tên as separate fields plus
-- phone/address/avatar — `full_name` is kept in sync (`first_name || ' ' ||
-- last_name`) so existing Dashboard/Profile code that only reads `full_name`
-- keeps working unchanged.
alter table public.profiles add column if not exists first_name text;
alter table public.profiles add column if not exists last_name text;
alter table public.profiles add column if not exists phone text;
alter table public.profiles add column if not exists address text;
alter table public.profiles add column if not exists avatar_url text;

-- Dashboard's "Mục tiêu tiết kiệm {year}" progress card — a single
-- user-set target; progress is computed client-side from `transactions`
-- (year-to-date income minus expense), never stored here.
alter table public.profiles add column if not exists savings_goal_amount numeric(14, 2) not null default 0;

-- Backfill first_name/last_name for rows created before this migration —
-- first word becomes "Họ", the remainder becomes "Tên" (matches the design's
-- ho:'Nguyễn', ten:'Minh Anh' split for "Nguyễn Minh Anh"). Single-word names
-- go entirely into last_name so the required "Tên" field isn't left empty.
update public.profiles
set
  first_name = coalesce(first_name, case when full_name ~ '\s' then split_part(full_name, ' ', 1) else '' end),
  last_name = coalesce(
    last_name,
    case when full_name ~ '\s' then trim(substring(full_name from position(' ' in full_name))) else full_name end
  )
where first_name is null or last_name is null;

alter table public.profiles enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own" on public.profiles
  for select using (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
  for update using (auth.uid() = id);

-- Auto-create a profile row whenever a new user signs up.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, first_name, last_name, email)
  values (
    new.id,
    initcap(split_part(new.email, '@', 1)),
    '',
    initcap(split_part(new.email, '@', 1)),
    new.email
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============================================================
-- transactions — one row per income/expense entry. `expense_category` /
-- `income_source` store the Dart enum's `.name` verbatim (e.g. "anUong",
-- "luong") so TransactionModel.fromJson can parse them directly via
-- `ExpenseCategory.values.byName(...)`.
-- ============================================================
create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  type text not null check (type in ('expense', 'income')),
  amount numeric(14, 2) not null check (amount > 0),
  date date not null,
  expense_category text,
  income_source text,
  note text,
  created_at timestamptz not null default now(),
  constraint transactions_category_matches_type check (
    (type = 'expense' and expense_category is not null and income_source is null) or
    (type = 'income' and income_source is not null and expense_category is null)
  )
);

create index if not exists transactions_user_date_idx
  on public.transactions (user_id, date desc);

alter table public.transactions enable row level security;

drop policy if exists "transactions_select_own" on public.transactions;
create policy "transactions_select_own" on public.transactions
  for select using (auth.uid() = user_id);

drop policy if exists "transactions_insert_own" on public.transactions;
create policy "transactions_insert_own" on public.transactions
  for insert with check (auth.uid() = user_id);

drop policy if exists "transactions_update_own" on public.transactions;
create policy "transactions_update_own" on public.transactions
  for update using (auth.uid() = user_id);

drop policy if exists "transactions_delete_own" on public.transactions;
create policy "transactions_delete_own" on public.transactions
  for delete using (auth.uid() = user_id);

-- ============================================================
-- budgets — one row per category the user has set a monthly budget for.
-- `used` amounts are computed client-side from `transactions`, not stored
-- here, so they're never stale.
-- ============================================================
create table if not exists public.budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  category text not null,
  budget_amount numeric(14, 2) not null check (budget_amount > 0),
  created_at timestamptz not null default now(),
  unique (user_id, category)
);

alter table public.budgets enable row level security;

drop policy if exists "budgets_select_own" on public.budgets;
create policy "budgets_select_own" on public.budgets
  for select using (auth.uid() = user_id);

drop policy if exists "budgets_insert_own" on public.budgets;
create policy "budgets_insert_own" on public.budgets
  for insert with check (auth.uid() = user_id);

drop policy if exists "budgets_update_own" on public.budgets;
create policy "budgets_update_own" on public.budgets
  for update using (auth.uid() = user_id);

drop policy if exists "budgets_delete_own" on public.budgets;
create policy "budgets_delete_own" on public.budgets
  for delete using (auth.uid() = user_id);
