// =============================================================================
// create-client
//
// Creates a login account and its project in one call.
//
// Why this exists as a server function rather than in the dashboard:
// creating an auth user requires the service_role key, which bypasses every
// row level security policy. That key can never be shipped in a page, so the
// work has to happen somewhere the key is a secret. Here it comes from the
// environment, and Supabase injects it automatically.
//
// The caller is verified before anything is created: the request must carry a
// logged-in user's token, and that user must have role 'admin' in profiles.
// Without that check, anyone holding the publishable key could create accounts.
//
// Deploy:
//   supabase functions deploy create-client
// No secrets to set. SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are provided.
// =============================================================================

import { createClient } from 'jsr:@supabase/supabase-js@2';

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS, 'Content-Type': 'application/json' },
  });
}

const STAGES = ['שיחה', 'חומרים ואפיון', 'בנייה', 'עולים לאוויר'];

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: CORS });
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);

  const url = Deno.env.get('SUPABASE_URL')!;
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
  const anonKey = Deno.env.get('SUPABASE_ANON_KEY')!;

  // ---- 1. who is calling ----
  const authHeader = req.headers.get('Authorization') ?? '';
  if (!authHeader.startsWith('Bearer ')) return json({ error: 'unauthorized' }, 401);

  // A client bound to the caller's token, so RLS applies to this read exactly
  // as it would in the browser.
  const asCaller = createClient(url, anonKey, {
    global: { headers: { Authorization: authHeader } },
  });

  const { data: me, error: meErr } = await asCaller.auth.getUser();
  if (meErr || !me?.user) return json({ error: 'unauthorized' }, 401);

  const { data: profile } = await asCaller
    .from('profiles').select('role').eq('id', me.user.id).single();

  if (!profile || profile.role !== 'admin') return json({ error: 'forbidden' }, 403);

  // ---- 2. validate input ----
  let body: Record<string, unknown>;
  try { body = await req.json(); } catch { return json({ error: 'bad json' }, 400); }

  const email = String(body.email ?? '').trim().toLowerCase();
  const password = String(body.password ?? '');
  const clientName = String(body.client_name ?? '').trim();
  const brandName = String(body.brand_name ?? '').trim();

  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return json({ error: 'כתובת מייל לא תקינה' }, 400);
  if (password.length < 8) return json({ error: 'הסיסמה צריכה להיות באורך 8 תווים לפחות' }, 400);
  if (!brandName && !clientName) return json({ error: 'צריך שם לקוח או שם מותג' }, 400);

  const admin = createClient(url, serviceKey, { auth: { persistSession: false } });

  // ---- 3. create the user ----
  const { data: created, error: createErr } = await admin.auth.admin.createUser({
    email,
    password,
    email_confirm: true,           // no confirmation mail: the owner hands over the password
    user_metadata: { full_name: clientName },
  });

  if (createErr || !created?.user) {
    const msg = createErr?.message ?? 'user creation failed';
    const taken = /already/i.test(msg);
    return json({ error: taken ? 'כתובת המייל כבר רשומה' : msg }, taken ? 409 : 400);
  }

  const userId = created.user.id;

  // ---- 4. create the project, stages and materials ----
  // Anything failing from here leaves an account with no project, so the user
  // is removed again rather than left half-created.
  async function rollback(reason: string) {
    await admin.auth.admin.deleteUser(userId).catch(() => {});
    return json({ error: reason }, 400);
  }

  const { data: project, error: projErr } = await admin
    .from('projects')
    .insert({
      owner_id: userId,
      client_name: clientName,
      brand_name: brandName || clientName,
      start_date: String(body.start_date ?? ''),
      target_launch_date: String(body.target_launch_date ?? ''),
      last_updated: String(body.start_date ?? ''),
      wa_number: String(body.wa_number ?? ''),
      balance_due: 'לפני עלייה לאוויר',
    })
    .select('id')
    .single();

  if (projErr || !project) return await rollback(projErr?.message ?? 'project creation failed');

  const { error: stageErr } = await admin.from('stages').insert(
    STAGES.map((name, i) => ({
      project_id: project.id,
      position: i + 1,
      name,
      state: i === 0 ? 'done' : i === 1 ? 'waiting' : 'todo',
    })),
  );
  if (stageErr) return await rollback(stageErr.message);

  const materials = Array.isArray(body.materials) ? body.materials as string[] : [];
  if (materials.length) {
    const { error: matErr } = await admin.from('materials').insert(
      materials.filter(Boolean).map((item, i) => ({
        project_id: project.id,
        position: i + 1,
        item: String(item),
        state: 'missing',
        since: String(body.start_date ?? ''),
      })),
    );
    if (matErr) return await rollback(matErr.message);
  }

  return json({ ok: true, user_id: userId, project_id: project.id });
});
