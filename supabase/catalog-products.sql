-- Catálogo público de productos vinculado al inventario privado de Rescate del Día.
-- Ejecutar en el SQL Editor del mismo proyecto Supabase usado por ambas apps.
-- Un bot de reglas puede aprobar categorías permitidas; otros casos quedan pendientes para revisión manual.

create table if not exists public.catalog_products (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  inventory_product_id text not null,
  business_id text not null check (char_length(business_id) between 1 and 80),
  business_name text not null check (char_length(business_name) between 2 and 45),
  product_name text not null check (char_length(product_name) between 2 and 55),
  category text not null check (category in ('Panadería','Comida','Frutas y verduras','Otros')),
  zone text not null check (char_length(zone) between 2 and 60),
  whatsapp text not null check (whatsapp ~ '^[1-9][0-9]{9,14}$'),
  price_mxn numeric(10,2) not null check (price_mxn >= 0),
  available_stock integer not null default 0 check (available_stock >= 0),
  unit text not null check (char_length(unit) between 1 and 20),
  description text check (description is null or char_length(description) <= 240),
  product_seller_opt_in boolean not null default false,
  public_consent boolean not null default false check (public_consent = true),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (owner_id, inventory_product_id)
);

-- Safe upgrade for an existing catalog table: legacy rows remain ineligible by default.
alter table public.catalog_products add column if not exists product_seller_opt_in boolean not null default false;

create index if not exists catalog_products_public_idx
  on public.catalog_products (status, category, zone)
  where available_stock > 0;

alter table public.catalog_products enable row level security;

do $$
begin
  if exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'catalog_products' and policyname = 'catalog products public approved read') then
    alter policy "catalog products public approved read" on public.catalog_products
      using (status = 'approved' and available_stock > 0 and product_seller_opt_in = true
        and lower(business_name) not like '%autolavado%' and lower(business_id) not like '%autolavado%');
  else
    create policy "catalog products public approved read"
      on public.catalog_products for select to anon
      using (status = 'approved' and available_stock > 0 and product_seller_opt_in = true
        and lower(business_name) not like '%autolavado%' and lower(business_id) not like '%autolavado%');
  end if;
  if exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'catalog_products' and policyname = 'catalog products authenticated read') then
    alter policy "catalog products authenticated read" on public.catalog_products
      using ((status = 'approved' and available_stock > 0 and product_seller_opt_in = true
        and lower(business_name) not like '%autolavado%' and lower(business_id) not like '%autolavado%') or owner_id = auth.uid());
  else
    create policy "catalog products authenticated read"
      on public.catalog_products for select to authenticated
      using ((status = 'approved' and available_stock > 0 and product_seller_opt_in = true
        and lower(business_name) not like '%autolavado%' and lower(business_id) not like '%autolavado%') or owner_id = auth.uid());
  end if;
  if exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'catalog_products' and policyname = 'catalog products owner insert pending') then
    alter policy "catalog products owner insert pending" on public.catalog_products
      with check (owner_id = auth.uid() and product_seller_opt_in = true and public_consent = true
        and lower(business_name) not like '%autolavado%' and lower(business_id) not like '%autolavado%'
        and status in ('pending','approved'));
  else
    create policy "catalog products owner insert pending"
      on public.catalog_products for insert to authenticated
      with check (owner_id = auth.uid() and product_seller_opt_in = true and public_consent = true
        and lower(business_name) not like '%autolavado%' and lower(business_id) not like '%autolavado%'
        and status in ('pending','approved'));
  end if;
  if exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'catalog_products' and policyname = 'catalog products owner update') then
    alter policy "catalog products owner update" on public.catalog_products
      using (owner_id = auth.uid())
      with check (owner_id = auth.uid() and product_seller_opt_in = true and public_consent = true
        and lower(business_name) not like '%autolavado%' and lower(business_id) not like '%autolavado%');
  else
    create policy "catalog products owner update"
      on public.catalog_products for update to authenticated
      using (owner_id = auth.uid())
      with check (owner_id = auth.uid() and product_seller_opt_in = true and public_consent = true
        and lower(business_name) not like '%autolavado%' and lower(business_id) not like '%autolavado%');
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'catalog_products' and policyname = 'catalog products owner delete') then
    create policy "catalog products owner delete"
      on public.catalog_products for delete to authenticated
      using (owner_id = auth.uid());
  end if;
end;
$$;

revoke all on public.catalog_products from anon, authenticated;
grant select (id, business_name, product_name, category, zone, whatsapp, price_mxn, available_stock, unit, description, status, product_seller_opt_in, updated_at)
  on public.catalog_products to anon;
grant select on public.catalog_products to authenticated;
grant insert (owner_id, inventory_product_id, business_id, business_name, product_name, category, zone, whatsapp, price_mxn, available_stock, unit, description, product_seller_opt_in, public_consent)
  on public.catalog_products to authenticated;
grant update (business_id, business_name, product_name, category, zone, whatsapp, price_mxn, available_stock, unit, description, product_seller_opt_in, public_consent)
  on public.catalog_products to authenticated;
grant delete on public.catalog_products to authenticated;

create or replace function public.catalog_products_touch_updated_at()
returns trigger
language plpgsql
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

revoke all on function public.catalog_products_touch_updated_at() from public;
do $$
begin
  if not exists (
    select 1 from pg_trigger
    where tgname = 'catalog_products_updated_at'
      and tgrelid = 'public.catalog_products'::regclass
      and not tgisinternal
  ) then
    create trigger catalog_products_updated_at
      before update on public.catalog_products
      for each row execute function public.catalog_products_touch_updated_at();
  end if;
end;
$$;

-- Rule-based approval: low-risk food categories can be approved automatically.
-- Unusual categories or restricted-item keywords stay pending for manual review.
create or replace function public.catalog_products_auto_review()
returns trigger
language plpgsql
security definer
set search_path = pg_catalog, public
as $$
declare
  v_text text;
begin
  new.status := 'pending';
  v_text := lower(coalesce(new.product_name, '') || ' ' || coalesce(new.description, ''));
  if new.product_seller_opt_in is true
    and new.public_consent is true
    and new.available_stock > 0
    and new.price_mxn > 0
    and new.category in ('Panadería','Comida','Frutas y verduras')
    and lower(new.business_name) not like '%autolavado%'
    and lower(new.business_id) not like '%autolavado%'
    and v_text !~ '(medic|farmac|drog|armas?|pistola|munici[oó]n|explosiv|alcohol|cerveza|vino|tabaco|cigar|vape|marihuana|cannabis)'
  then
    new.status := 'approved';
  end if;
  return new;
end;
$$;
revoke all on function public.catalog_products_auto_review() from public, anon, authenticated;

do $$
begin
  if not exists (
    select 1 from pg_trigger
    where tgname = 'catalog_products_auto_review'
      and tgrelid = 'public.catalog_products'::regclass
      and not tgisinternal
  ) then
    create trigger catalog_products_auto_review
      before insert on public.catalog_products
      for each row execute function public.catalog_products_auto_review();
  end if;
end;
$$;
