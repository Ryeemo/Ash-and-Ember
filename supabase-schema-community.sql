-- Run this in Supabase: Project → SQL Editor → New query → paste → Run
-- Adds a shared pool of cigars discovered via "new releases" search, visible to everyone,
-- separate from each person's private ratings/library/humidor.

create table if not exists public.community_cigars (
  id text primary key,
  added_by uuid references auth.users(id) on delete set null,
  brand text not null,
  line text not null,
  vitola text,
  wrapper text,
  color text,
  strength int,
  flavors jsonb default '[]'::jsonb,
  origin text,
  price text,
  size text,
  added_ts bigint not null
);

alter table public.community_cigars enable row level security;

-- Anyone can read the shared pool, signed in or not.
create policy "Anyone can view community cigars" on public.community_cigars
  for select using (true);

-- Only signed-in users can add, and only attributed to themselves.
create policy "Signed in users can add community cigars" on public.community_cigars
  for insert with check (auth.uid() = added_by);

-- Only the person who added an entry can remove it later.
create policy "Users can delete their own community additions" on public.community_cigars
  for delete using (auth.uid() = added_by);
