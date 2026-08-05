# Coursely

A small multi-tenant course platform. Two institutions, three roles, announcements,
submissions, and grading.

This is the application you are assessing. Read the assignment in the packet root first.

## Setup

You need a Supabase database and Node. **Pick whichever of these suits your machine.**

**Option A — a free cloud project.** No Docker, works on a locked-down machine.

1. Create a project at [supabase.com](https://supabase.com) (free tier is plenty).
2. **Project Settings → Database → Connection string → URI**, substituting your password.
3. **Project Settings → API** for the project URL, the `anon` key, and the `service_role` key.

**Option B — run it locally.** Needs Docker and the Supabase CLI.

```bash
supabase init && supabase start     # prints your URL, keys and DB URL
```

**Then, either way:**

```bash
cd supabase/setup
npm install
node setup.mjs "<your-connection-string>"     # applies schema + seed, then verifies

cd ../..
cp .env.example .env.local                    # fill in the URL and keys
npm install
npm run dev
```

`node setup.mjs "<conn>" --reset` starts over. It only drops what this exercise created.

If any of this gives you trouble, that is our problem and not part of the exercise — email us
rather than burning your time budget on it.

> **A note if you use a cloud project:** you are going to be attacking this database. Use a
> project created solely for this exercise, and delete it when you're done. Do not point it at
> anything else, and do not put anything real in it.

## Accounts

Every account's password is `TakeHome123!`.

| Email | Institution | Role |
|---|---|---|
| `prof@meridian.edu` | Meridian College | professor |
| `admin@meridian.edu` | Meridian College | admin |
| `sam@meridian.edu` | Meridian College | student |
| `juno@meridian.edu` | Meridian College | student |
| `prof@lakeside.edu` | Lakeside Polytechnic | professor |
| `iris@lakeside.edu` | Lakeside Polytechnic | student |

Having credentials at **both** institutions is deliberate. The most interesting question you
can ask this application is what a Lakeside user can reach at Meridian.

## Layout

```
supabase/
  01-schema.sql      tables, RLS policies, and helper functions
  02-seed.sql        both institutions, with data
src/
  lib/supabase/      server and admin clients
  app/               pages and server actions
  components/        client components
```

Both SQL files are worth reading closely. Not everything in this application is reachable
from the user interface.

## Scope

This application, its database, and its API. Nothing else — see the assignment for the full
rule, which is not negotiable.
