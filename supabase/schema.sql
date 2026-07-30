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

-- Auto-create a profile row + the 9 expense / 4 income default categories
-- whenever a new user signs up (mirrors the custom backend's own signup
-- seeding, so both data sources present the same starting taxonomy).
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

  insert into public.categories (user_id, label, icon, color, type, is_default)
  values
    (new.id, 'Ăn uống', 'restaurant', '#4F46E5', 'expense', false),
    (new.id, 'Shopping', 'shopping_bag', '#F59E0B', 'expense', false),
    (new.id, 'Đi lại', 'directions_car', '#22C55E', 'expense', false),
    (new.id, 'Giải trí', 'sports_esports', '#F43F5E', 'expense', false),
    (new.id, 'Y tế', 'medical_services', '#0EA5E9', 'expense', false),
    (new.id, 'Gia đình', 'home', '#8B5CF6', 'expense', false),
    (new.id, 'Du lịch', 'flight', '#14B8A6', 'expense', false),
    (new.id, 'Thú cưng', 'pets', '#EAB308', 'expense', false),
    (new.id, 'Khác', 'category', '#94A3B8', 'expense', true),
    (new.id, 'Lương', 'payments', '#22C55E', 'income', false),
    (new.id, 'Freelance', 'laptop_mac', '#4F46E5', 'income', false),
    (new.id, 'Bonus', 'redeem', '#F59E0B', 'income', false),
    (new.id, 'Khác', 'more_horiz', '#94A3B8', 'income', true);

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

-- ============================================================
-- categories — the single source of truth for both expense and income
-- categorization app-wide (Add Transaction, Budget, Dashboard, Reports,
-- Calendar, History, Category Management). Replaces the old fixed
-- ExpenseCategory/IncomeSource enums.
-- ============================================================
create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  label text not null,
  icon text not null,
  color text not null,
  created_at timestamptz not null default now()
);

-- Mirrors the custom backend's rule that its auto-seeded "Khác" category
-- can't be deleted — always false here, since Supabase mode never creates
-- default categories of its own.
alter table public.categories add column if not exists is_default boolean not null default false;

create index if not exists categories_user_created_idx
  on public.categories (user_id, created_at);

alter table public.categories enable row level security;

drop policy if exists "categories_select_own" on public.categories;
create policy "categories_select_own" on public.categories
  for select using (auth.uid() = user_id);

drop policy if exists "categories_insert_own" on public.categories;
create policy "categories_insert_own" on public.categories
  for insert with check (auth.uid() = user_id);

drop policy if exists "categories_update_own" on public.categories;
create policy "categories_update_own" on public.categories
  for update using (auth.uid() = user_id);

drop policy if exists "categories_delete_own" on public.categories;
create policy "categories_delete_own" on public.categories
  for delete using (auth.uid() = user_id);

-- ============================================================
-- Category unification migration — adds `type`, backfills default
-- categories for users created before this migration (new signups get them
-- via `handle_new_user()` above), then repoints transactions/budgets at
-- real category rows instead of the old fixed-enum-name text columns.
-- ============================================================
alter table public.categories add column if not exists type text not null default 'expense' check (type in ('expense', 'income'));

insert into public.categories (user_id, label, icon, color, type, is_default)
select u.id, d.label, d.icon, d.color, d.type, d.is_default
from auth.users u
cross join (values
  ('Ăn uống', 'restaurant', '#4F46E5', 'expense', false),
  ('Shopping', 'shopping_bag', '#F59E0B', 'expense', false),
  ('Đi lại', 'directions_car', '#22C55E', 'expense', false),
  ('Giải trí', 'sports_esports', '#F43F5E', 'expense', false),
  ('Y tế', 'medical_services', '#0EA5E9', 'expense', false),
  ('Gia đình', 'home', '#8B5CF6', 'expense', false),
  ('Du lịch', 'flight', '#14B8A6', 'expense', false),
  ('Thú cưng', 'pets', '#EAB308', 'expense', false),
  ('Khác', 'category', '#94A3B8', 'expense', true),
  ('Lương', 'payments', '#22C55E', 'income', false),
  ('Freelance', 'laptop_mac', '#4F46E5', 'income', false),
  ('Bonus', 'redeem', '#F59E0B', 'income', false),
  ('Khác', 'more_horiz', '#94A3B8', 'income', true)
) as d(label, icon, color, type, is_default)
where not exists (
  select 1 from public.categories c
  where c.user_id = u.id and c.label = d.label and c.type = d.type
);

-- transactions: category_id replaces expense_category/income_source.
alter table public.transactions add column if not exists category_id uuid references public.categories (id);

update public.transactions t
set category_id = c.id
from public.categories c
where t.category_id is null
  and c.user_id = t.user_id
  and c.type = t.type
  and c.label = case
    when t.type = 'expense' then case t.expense_category
      when 'anUong' then 'Ăn uống'
      when 'shopping' then 'Shopping'
      when 'diLai' then 'Đi lại'
      when 'giaiTri' then 'Giải trí'
      when 'yTe' then 'Y tế'
      when 'giaDinh' then 'Gia đình'
      when 'duLich' then 'Du lịch'
      when 'thuCung' then 'Thú cưng'
      else 'Khác'
    end
    else case t.income_source
      when 'luong' then 'Lương'
      when 'freelance' then 'Freelance'
      when 'bonus' then 'Bonus'
      else 'Khác'
    end
  end;

-- If this fails, some rows have expense_category/income_source values that
-- don't match any label above (e.g. hand-edited data) — fix those rows
-- before re-running.
alter table public.transactions alter column category_id set not null;
alter table public.transactions drop constraint if exists transactions_category_matches_type;
alter table public.transactions drop column if exists expense_category;
alter table public.transactions drop column if exists income_source;

create index if not exists transactions_category_idx
  on public.transactions (category_id);

-- budgets: category_id replaces the enum-name `category` text column.
alter table public.budgets add column if not exists category_id uuid references public.categories (id);

update public.budgets b
set category_id = c.id
from public.categories c
where b.category_id is null
  and c.user_id = b.user_id
  and c.type = 'expense'
  and c.label = case b.category
    when 'anUong' then 'Ăn uống'
    when 'shopping' then 'Shopping'
    when 'diLai' then 'Đi lại'
    when 'giaiTri' then 'Giải trí'
    when 'yTe' then 'Y tế'
    when 'giaDinh' then 'Gia đình'
    when 'duLich' then 'Du lịch'
    when 'thuCung' then 'Thú cưng'
    else 'Khác'
  end;

alter table public.budgets alter column category_id set not null;
alter table public.budgets drop column if exists category cascade;

do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'budgets_user_category_id_key'
  ) then
    alter table public.budgets add constraint budgets_user_category_id_key unique (user_id, category_id);
  end if;
end $$;
