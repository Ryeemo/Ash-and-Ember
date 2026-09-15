-- Run this in Supabase: Project → SQL Editor → New query → paste → Run
-- Adds support for multiple named humidors and an aging date per item.
-- Safe to run even if you have existing humidor_items — it migrates them
-- into a default "My Humidor" automatically.

-- 1. New table: humidors (the containers themselves)
create table if not exists public.humidors (
  id text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  created_ts bigint not null,
  primary key (id, user_id)
);

alter table public.humidors enable row level security;

create policy "Users manage own humidors" on public.humidors
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 2. Extend humidor_items with the new columns
alter table public.humidor_items add column if not exists humidor_id text;
alter table public.humidor_items add column if not exists date_added text;

update public.humidor_items set humidor_id = 'default' where humidor_id is null;
update public.humidor_items set date_added = to_char(to_timestamp(added_ts / 1000.0), 'YYYY-MM-DD') where date_added is null;

-- Create a default humidor for anyone who already has items, so nothing orphans.
insert into public.humidors (id, user_id, name, created_ts)
select distinct 'default', user_id, 'My Humidor', extract(epoch from now()) * 1000
from public.humidor_items
on conflict (id, user_id) do nothing;

-- 3. Re-key humidor_items so id = "<humidorId>::<cigarId>", unique per user.
alter table public.humidor_items alter column id drop default;
alter table public.humidor_items alter column id type text using (humidor_id || '::' || cigar_id);

alter table public.humidor_items drop constraint if exists humidor_items_user_id_cigar_id_key;
alter table public.humidor_items drop constraint if exists humidor_items_pkey;
alter table public.humidor_items add constraint humidor_items_pkey primary key (id, user_id);
