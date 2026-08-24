# Deploying

Same two services you already use for Tiyul+, with two differences worth knowing
up front:

1. **There is no build step.** The site is static HTML. No `npm install`, no
   `next build`.
2. **There are no environment variables.** On Tiyul+ the keys are injected at
   build time through `NEXT_PUBLIC_...`. There is no build here, so the URL and
   the API key are written directly into `app/dashboard.html`. That is fine,
   and step 6 explains why.

---

## Part 1 - Supabase

### 1. A new project, not the Tiyul+ one

Create a fresh Supabase project. Do not reuse the Tiyul+ project.

`auth.users` is one table per project. Sharing a project puts Tiyul+ users and
your clients in the same pool, where one mistake in a policy reaches across
both. The free tier allows two active projects, so this costs nothing.

While creating it:

- **Region:** `Frankfurt (eu-central-1)` is the closest to Israel.
- **Database password:** store it in a password manager. This page never needs
  it, but without it there is no direct access to the database.

### 2. Run the schema

In the new project: **SQL Editor** -> **New query** -> paste the whole contents
of `supabase/schema.sql` -> **Run**.

It should return `Success. No rows returned`. That creates four tables, nine
row level security policies, and a trigger that gives every new user a profile.

### 3. Create your admin account

**Authentication** -> **Users** -> **Add user** -> **Create new user**.

- Email: yours
- Password: pick one
- Tick **Auto Confirm User**, otherwise you have to confirm by email first

Then promote that account. Back in **SQL Editor**, with your address:

```sql
update public.profiles set role = 'admin'
where id = (select id from auth.users where email = 'natikyan153@gmail.com');
```

Check it took:

```sql
select u.email, p.role from public.profiles p
join auth.users u on u.id = p.id;
```

One row, role `admin`.

### 4. Turn off self-signup

**Authentication** -> **Sign In / Providers** -> **Email** -> turn off
**Allow new users to sign up**.

Without this anyone can create an account. They would see nothing, because the
policies return an empty list to a user with no project, but there is no reason
to leave it open. You create every client by hand.

### 5. Copy the URL and key

Supabase moved this page and renamed the keys, so older guides point at the
wrong place. Current locations:

**Project URL** - **Settings** -> **Data API**, field `Project URL`. Looks like
`https://abcdefgh.supabase.co`. It is also in the **Connect** dialog at the top
of the dashboard.

**The key** - **Settings** -> **API Keys** -> **Publishable key**. It starts with
`sb_publishable_`.

Key naming changed in 2025:

| old name | new name | use |
|---|---|---|
| `anon` | Publishable key `sb_publishable_...` | this is the one you want |
| `service_role` | Secret key `sb_secret_...` | never in a page |

If your project still shows the old pair, they are under a **Legacy API keys**
tab and the `anon` key works exactly the same. Legacy keys are being retired at
the end of 2026, so prefer the publishable key if both are offered.

> **Never take the secret key.** It bypasses every policy. In a page it hands
> full access to every client's data to anyone who opens view-source.

### 6. Paste them into the file

Open `app/dashboard.html`. At the top, inside the `EDIT ZONE` block:

```js
const SUPABASE_URL = 'https://abcdefgh.supabase.co';
const SUPABASE_KEY = 'sb_publishable_...';
```

**Why shipping this key is safe:** it is designed to be public. The same key
reaches the browser on Tiyul+ too, just via `NEXT_PUBLIC_`. On its own it grants
nothing, because every table sits behind row level security. The policies in the
database are what protect the data, not the secrecy of the key.

---

## Part 2 - Vercel

### 7. Import the repo

In Vercel: **Add New** -> **Project** -> pick `netanelyan/blackz-web`.

On the configuration screen:

| Field | Value |
|---|---|
| Framework Preset | `Other` |
| Build Command | leave empty |
| Output Directory | leave empty |
| Install Command | leave empty |
| Environment Variables | none needed |

Hit **Deploy**. It takes seconds, because there is nothing to build.

### 8. What ships and what does not

`.vercelignore` keeps these out of the deployment:

- `internal/` - the internal sales sheet. **It has no login.** Deployed, anyone
  with the link sees your floor price, your qualifying questions and your red
  flags. A prospect who finds it knows you will come down to 4,500 before the
  conversation starts.
- `supabase/` - the schema. No reason to publish it.
- `scripts/`, `.github/`, `CLAUDE.md`, `translations.txt` - repo tooling.

`vercel.json` adds security headers and marks `/app`, `/c` and `/internal` as
`noindex` so they stay out of search results.

There is deliberately no `robots.txt` entry for those paths. A `Disallow:` line
publishes a list of your private directories to anyone who reads the file. The
header does the same job without advertising them.

### 9. Domain

**Settings** -> **Domains** -> add your domain.

Once it resolves, update the two fields in `index.html` that still point at a
dummy address: `og:url` and the commented-out `og:image`. Without them the
WhatsApp link preview comes out half empty.

---

### 6b. The remaining migrations and the create-client function

Two more SQL files, run once each in the SQL editor:

- `supabase/002_objections.sql` - the editable objection answers
- `supabase/003_quote_items.sql` - the quote catalogue
- `supabase/004_prices.sql` - the prices themselves
- `supabase/005_quote_files.sql` - the private bucket for signed quotes

Then deploy the function that creates client accounts. No CLI needed:

1. Supabase dashboard -> **Edge Functions** in the left sidebar
2. **Deploy a new function** -> **Via editor**
3. Name it exactly `create-client`. The dashboard calls
   `/functions/v1/create-client`, so a different name will 404.
4. Delete the template code in the editor
5. Paste the entire contents of `supabase/functions/create-client/index.ts`
6. **Deploy**

Leave **Verify JWT** on. The dashboard sends the logged-in user's token, and
that setting makes Supabase reject anonymous calls before your code even runs.

Nothing to configure: Supabase injects the service_role key into the function
environment by itself.

If you would rather use the CLI:

```bash
npx supabase login
npx supabase link --project-ref yaeralfvkrqlxhwavczz
npx supabase functions deploy create-client
```

To check it worked, open the new-client tab. If it still says the function is
not deployed, the name does not match.

**Why an account needs a function at all.** Creating a login requires the
service_role key, which bypasses every policy. That key can never sit in a page,
so the work has to run somewhere it stays secret. The function verifies the
caller is a logged-in admin before creating anything, and deletes the new
account again if the project insert fails, so a login never exists without a
project behind it.

Until it is deployed the new-client tab says exactly that instead of failing
silently.

---

## Part 3 - Check it works

1. Open `https://<your-domain>/app/dashboard.html`
2. Sign in with the account from step 3
3. You should see `מנהל` in the corner and an empty project list

If you get `אימייל או סיסמה שגויים`, the account was not confirmed. Go back to
Authentication -> Users and check it shows `Confirmed`.

If you get the setup warning about the URL and key, step 6 was not saved or not
pushed.

---

## Part 4 - Adding a client

### 10. The user

**Authentication** -> **Users** -> **Add user**, with the client's email, a
temporary password, and **Auto Confirm User** ticked. Copy the `User UID`.

### 11. The project

In **SQL Editor**, using that UID:

```sql
insert into public.projects
  (owner_id, client_name, brand_name, start_date, target_launch_date,
   last_updated, upload_url, wa_number, balance_due)
values
  ('PASTE-THE-UID-HERE',
   'client name',
   'brand name',
   '12 בינואר',
   '9 בפברואר',
   '12 בינואר',
   'https://www.dropbox.com/request/...',
   '972515310498',
   'לפני עלייה לאוויר')
returning id;
```

Take the returned `id` and create the four stages:

```sql
select public.seed_stages('PASTE-THE-PROJECT-ID-HERE');
```

Then the materials you are waiting on:

```sql
insert into public.materials (project_id, position, item, state, since) values
  ('PROJECT-ID', 1, 'רשימת מוצרים ומחירים', 'missing', '12 בינואר'),
  ('PROJECT-ID', 2, 'תמונות מוצר',          'missing', '12 בינואר'),
  ('PROJECT-ID', 3, 'לוגו',                  'missing', '12 בינואר'),
  ('PROJECT-ID', 4, 'גישה לדומיין',          'skip',    '');
```

### 12. Send it

Give the client the dashboard URL, their email and the temporary password. From
then on every status change happens in the dashboard itself, with no code and
no SQL.

---

## Maintenance

- **Status updates:** in the dashboard, from your phone. Open a project, change
  stages and materials, save.
- **Code changes:** `git push` to `main`. Vercel deploys automatically.
- **The screenshot bot:** the GitHub Action pushes to the repo weekly. That push
  also triggers a Vercel deploy. This is expected and needs no action.

## Cost

The free tier on both services is enough at this volume. Nothing to upgrade.
