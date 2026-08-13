-- =============================================================================
-- Senegal Interior Design — Supabase setup
-- Run this once in: Supabase Dashboard -> SQL Editor -> New query -> Run
-- =============================================================================

-- 1. Categories table. Seeded with the 5 built-in collections already on the
--    site; the admin can add more from admin.html and they show up on the
--    live site automatically (own filter tab + section).
create table if not exists public.categories (
    slug        text primary key,
    label       text not null,
    sort_order  int not null default 0,
    created_at  timestamptz not null default now()
);

insert into public.categories (slug, label, sort_order) values
    ('sofas', 'Sofas & Seating', 1),
    ('media', 'Media Walls & TV Stands', 2),
    ('wardrobes', 'Wardrobes & Storage', 3),
    ('dining', 'Dining', 4),
    ('kitchens', 'Kitchens & Interiors', 5)
on conflict (slug) do nothing;

-- 2. Table that stores every product the admin adds through admin.html.
--    category references categories.slug, so it can be any category that
--    exists (the original 5, or one the admin added) — not a fixed list.
create table if not exists public.products (
    id           uuid primary key default gen_random_uuid(),
    name         text not null,
    category     text not null references public.categories(slug),
    description  text,
    image_url    text not null,
    created_at   timestamptz not null default now()
);

-- 3. Lock both tables down. RLS is what actually protects your data — NOT
--    the secrecy of the anon key (that key is meant to be public).
alter table public.products enable row level security;
alter table public.categories enable row level security;

-- 4. Anyone (including logged-out visitors) can READ products and
--    categories — this is a public product catalog.
drop policy if exists "Public can view products" on public.products;
create policy "Public can view products"
    on public.products
    for select
    to anon, authenticated
    using (true);

drop policy if exists "Public can view categories" on public.categories;
create policy "Public can view categories"
    on public.categories
    for select
    to anon, authenticated
    using (true);

-- 5. Only the one admin account can add/edit/delete products or categories.
--    admin.html logs in with a plain "Username" (e.g. "admin"), which the
--    page turns into "admin@senegalinteriordesign.local" before talking to
--    Supabase — Supabase Auth always needs an email shape under the hood,
--    even though nothing is ever actually emailed to that address.
--    !! If you pick a different username than "admin" in step 6 below,
--    change the address below to match (same "@senegalinteriordesign.local"
--    ending). You can list more than one admin with:
--    auth.jwt() ->> 'email' in ('admin@senegalinteriordesign.local', 'assistant@senegalinteriordesign.local')
drop policy if exists "Admin can insert products" on public.products;
create policy "Admin can insert products"
    on public.products
    for insert
    to authenticated
    with check (auth.jwt() ->> 'email' = 'admin@senegalinteriordesign.local');

drop policy if exists "Admin can update products" on public.products;
create policy "Admin can update products"
    on public.products
    for update
    to authenticated
    using (auth.jwt() ->> 'email' = 'admin@senegalinteriordesign.local')
    with check (auth.jwt() ->> 'email' = 'admin@senegalinteriordesign.local');

drop policy if exists "Admin can delete products" on public.products;
create policy "Admin can delete products"
    on public.products
    for delete
    to authenticated
    using (auth.jwt() ->> 'email' = 'admin@senegalinteriordesign.local');

drop policy if exists "Admin can insert categories" on public.categories;
create policy "Admin can insert categories"
    on public.categories
    for insert
    to authenticated
    with check (auth.jwt() ->> 'email' = 'admin@senegalinteriordesign.local');

drop policy if exists "Admin can update categories" on public.categories;
create policy "Admin can update categories"
    on public.categories
    for update
    to authenticated
    using (auth.jwt() ->> 'email' = 'admin@senegalinteriordesign.local')
    with check (auth.jwt() ->> 'email' = 'admin@senegalinteriordesign.local');

drop policy if exists "Admin can delete categories" on public.categories;
create policy "Admin can delete categories"
    on public.categories
    for delete
    to authenticated
    using (auth.jwt() ->> 'email' = 'admin@senegalinteriordesign.local');

-- =============================================================================
-- 6. Create the admin login (do this once, in the dashboard — NOT in SQL):
--    Authentication -> Users -> Add User -> Create new user
--      Email:    admin@senegalinteriordesign.local   (this is your "Username" —
--                type just "admin" when logging into admin.html)
--      Password: pick a strong one, this is what you'll actually type in
--      Auto Confirm User: make sure this is turned ON
--    That's the only account that will ever be able to sign in to admin.html.
--    You can change this password any time from inside admin.html itself
--    (top-right "Change Password" button) — no need to come back here for that.
--
-- 7. Recommended: Authentication -> Providers -> Email -> turn OFF
--    "Allow new users to sign up". There is no sign-up form in admin.html,
--    but disabling it in Supabase too is a good extra safety net so nobody
--    can self-register an account even by calling the API directly.
-- =============================================================================
