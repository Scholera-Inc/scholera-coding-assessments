// Applies schema + seed to whatever Postgres you point it at: a local `supabase start`
// stack, or a free cloud Supabase project. Same command either way.

import { readFileSync, existsSync } from 'node:fs'
import { fileURLToPath } from 'node:url'
import { dirname, join } from 'node:path'
import pg from 'pg'

const HERE = dirname(fileURLToPath(import.meta.url))
const SQL_DIR = join(HERE, '..')

const args = process.argv.slice(2)
const reset = args.includes('--reset')
const conn = args.find((a) => a.startsWith('postgres')) || process.env.DATABASE_URL

if (!conn) {
  console.error(`
Usage:  node setup.mjs "<connection-string>" [--reset]

Where to find your connection string:

  Local Supabase   run: supabase status
                   use the "DB URL" it prints
                   (usually postgresql://postgres:postgres@127.0.0.1:54322/postgres)

  Cloud Supabase   Project Settings -> Database -> Connection string -> URI
                   Use the "Session pooler" or "Direct connection" string and
                   substitute your database password.

  --reset          drop this exercise's tables first, then reload. Safe to re-run.
`)
  process.exit(1)
}

// Tables this exercise owns. --reset only ever touches these, never anything else
// in the database.
const OWNED = [
  'team_messages', 'team_members', 'teams', 'projects',
  'private_notes', 'submissions', 'announcements',
  'enrollments', 'sections', 'courses', 'profiles', 'institutions',
]

const client = new pg.Client({
  connectionString: conn,
  ssl: conn.includes('supabase.co') ? { rejectUnauthorized: false } : undefined,
})

function step(msg) { process.stdout.write(`  ${msg} … `) }
function ok(extra = '') { console.log(`\x1b[32mok\x1b[0m${extra ? ' ' + extra : ''}`) }

try {
  console.log('\nScholera take-home — database setup\n')

  step('connecting')
  await client.connect()
  ok()

  // Sanity check: this must be a Supabase database, or the seed's auth.users
  // inserts will fail in a confusing way.
  const { rows: [{ has_auth }] } = await client.query(
    `SELECT EXISTS (SELECT 1 FROM information_schema.tables
       WHERE table_schema = 'auth' AND table_name = 'users') AS has_auth`,
  )
  if (!has_auth) {
    console.log('\x1b[31mfailed\x1b[0m')
    console.error(`
This database has no auth.users table, so it is not a Supabase project.

Point the script at a Supabase database — either a local stack (supabase start)
or a free project at supabase.com. A plain Postgres will not work.
`)
    process.exit(1)
  }

  if (reset) {
    step('dropping existing exercise tables')
    for (const t of OWNED) await client.query(`DROP TABLE IF EXISTS public.${t} CASCADE`)
    await client.query(`DELETE FROM auth.identities WHERE provider_id LIKE '%@%'
      AND user_id IN (SELECT id FROM auth.users WHERE email LIKE '%@northgate.edu'
        OR email LIKE '%@riverside.edu' OR email LIKE '%@meridian.edu' OR email LIKE '%@lakeside.edu')`)
    await client.query(`DELETE FROM auth.users WHERE email LIKE '%@northgate.edu'
      OR email LIKE '%@riverside.edu' OR email LIKE '%@meridian.edu' OR email LIKE '%@lakeside.edu'`)
    ok()
  }

  for (const file of ['01-schema.sql', '02-seed.sql']) {
    const path = join(SQL_DIR, file)
    if (!existsSync(path)) throw new Error(`missing ${file} — run this from the setup/ folder`)
    step(`applying ${file}`)
    await client.query(readFileSync(path, 'utf8'))
    ok()
  }

  // ── Verify, rather than assuming it worked ────────────────────────────────
  console.log('\nVerifying:')

  const { rows: insts } = await client.query('SELECT name FROM institutions ORDER BY name')
  console.log(`  institutions   ${insts.length}  (${insts.map((r) => r.name).join(', ')})`)

  const { rows: [{ count: users }] } =
    await client.query(`SELECT COUNT(*)::int FROM auth.users WHERE email LIKE '%@%'`)
  const { rows: [{ count: profiles }] } =
    await client.query('SELECT COUNT(*)::int FROM profiles')
  console.log(`  auth users     ${users}`)
  console.log(`  profiles       ${profiles}`)

  if (insts.length < 2) throw new Error('expected two institutions — seed did not apply cleanly')
  if (users !== profiles) throw new Error(`auth users (${users}) and profiles (${profiles}) disagree`)

  // Every seeded user needs an identity row or password sign-in misbehaves on
  // recent GoTrue versions.
  const { rows: [{ count: identities }] } = await client.query(
    `SELECT COUNT(*)::int FROM auth.identities i
       JOIN auth.users u ON u.id = i.user_id`,
  )
  console.log(`  identities     ${identities}`)
  if (identities < profiles) throw new Error('some users have no auth.identities row; sign-in will fail')

  console.log(`
\x1b[32mReady.\x1b[0m Every account's password is: TakeHome123!

See the table of accounts in SETUP.md — which user is interesting, and why.
`)
} catch (err) {
  console.log('\x1b[31mfailed\x1b[0m')
  console.error(`\n${err.message}\n`)
  console.error('If this looks like our problem rather than yours, email us. Setup should not')
  console.error('cost you any of your time budget.\n')
  process.exit(1)
} finally {
  await client.end().catch(() => {})
}
