-- CercaCerca: directorio compartido con publicación bajo revisión.
-- Ejecutar en Supabase SQL Editor. No poner la service_role key en la web.

create table if not exists public.providers (
  id uuid primary key default gen_random_uuid(),
  display_name text not null check (char_length(display_name) between 2 and 70),
  service text not null check (char_length(service) between 2 and 90),
  category text not null check (category in ('Hogar','Reparaciones','Belleza','Automotriz','Clases','Otros')),
  zone text not null check (char_length(zone) between 2 and 60),
  whatsapp text not null check (whatsapp ~ '^[1-9][0-9]{9,14}$'),
  price_from_mxn numeric(10,2) check (price_from_mxn is null or price_from_mxn >= 0),
  hours text check (hours is null or char_length(hours) <= 80),
  description text check (description is null or char_length(description) <= 240),
  public_consent boolean not null default false check (public_consent = true),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now()
);

alter table public.providers enable row level security;

-- Los visitantes solo pueden leer fichas aprobadas.
drop policy if exists "approved providers are public" on public.providers;
create policy "approved providers are public"
  on public.providers for select to anon
  using (status = 'approved');

-- Cualquier envío requiere consentimiento y queda pendiente; nunca se publica solo.
drop policy if exists "submit providers for review" on public.providers;
create policy "submit providers for review"
  on public.providers for insert to anon
  with check (status = 'pending' and public_consent = true);

revoke all on public.providers from anon, authenticated;
grant select on public.providers to anon;
grant insert (display_name, service, category, zone, whatsapp, price_from_mxn, hours, description, public_consent)
  on public.providers to anon;

-- Moderación manual desde el SQL Editor de Supabase:
-- Revisar:   select id, display_name, service, zone, whatsapp, created_at
--            from public.providers where status = 'pending' order by created_at;
-- Aprobar:   update public.providers set status = 'approved' where id = 'UUID';
-- Rechazar:  update public.providers set status = 'rejected' where id = 'UUID';
