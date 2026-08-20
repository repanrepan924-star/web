create table if not exists public.reports (
  id text primary key,
  ticket text not null unique,
  waktu timestamptz not null default now(),
  nama text not null,
  kontak text not null,
  alamat text not null,
  kategori text not null,
  urgensi text not null default 'Sedang',
  judul text not null,
  deskripsi text not null,
  status text not null default 'Menunggu',
  adminDecision text not null default 'Belum ditinjau',
  catatan text default ''
);

create table if not exists public.admin_users (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  email text not null unique,
  nama text,
  created_at timestamptz not null default now(),
  is_active boolean not null default true
);

alter table public.reports enable row level security;
alter table public.admin_users enable row level security;

create policy "Buka semua data untuk pembaca publik"
on public.reports
for select
using (true);

create policy "Insert laporan baru oleh publik"
on public.reports
for insert
with check (true);

create policy "Update laporan oleh admin"
on public.reports
for update
using (
  exists (
    select 1 from public.admin_users au
    where au.user_id = auth.uid()
      and au.is_active = true
  )
)
with check (
  exists (
    select 1 from public.admin_users au
    where au.user_id = auth.uid()
      and au.is_active = true
  )
);

create policy "Delete laporan oleh admin"
on public.reports
for delete
using (
  exists (
    select 1 from public.admin_users au
    where au.user_id = auth.uid()
      and au.is_active = true
  )
);

create policy "Admin melihat data admin sendiri"
on public.admin_users
for select
using (user_id = auth.uid());

create policy "Admin bisa menambah akun admin sendiri"
on public.admin_users
for insert
with check (user_id = auth.uid());

create policy "Admin bisa update akun admin sendiri"
on public.admin_users
for update
using (user_id = auth.uid())
with check (user_id = auth.uid());
