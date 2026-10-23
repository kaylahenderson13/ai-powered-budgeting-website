-- Run in Supabase SQL Editor. Demo uses fictional/non-sensitive amounts only.
create table if not exists public.entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  kind text not null check (kind in ('income','expense','debt')),
  category text not null check (char_length(category) between 1 and 60),
  description text not null default '' check (char_length(description) <= 200),
  amount numeric(12,2) not null check (amount > 0 and amount <= 100000000),
  entry_date date not null default current_date,
  created_at timestamptz not null default now()
);
create index if not exists entries_user_date_idx on public.entries(user_id,entry_date desc);
alter table public.entries enable row level security;
create policy "Users can view own entries" on public.entries for select to authenticated using ((select auth.uid())=user_id);
create policy "Users can insert own entries" on public.entries for insert to authenticated with check ((select auth.uid())=user_id);
create policy "Users can delete own entries" on public.entries for delete to authenticated using ((select auth.uid())=user_id);
-- If running the script more than once, existing policies may produce an already-exists error.
