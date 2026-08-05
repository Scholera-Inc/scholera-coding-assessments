# Setup

You need a Supabase database and Node. **Pick whichever of these two suits your machine** — the
setup command is identical either way.

If anything here gives you trouble, email us. Environment problems are our fault and should not
come out of your twelve hours.

## 1. Get a Supabase database

**Option A — a free cloud project.** No Docker, nothing to install, works on a locked-down
machine.

1. Sign up at [supabase.com](https://supabase.com) and create a new project (the free tier is
   plenty).
2. Wait for it to finish provisioning.
3. **Project Settings → Database → Connection string → URI.** Copy it and substitute the
   database password you chose.
4. **Project Settings → API.** You'll want the project URL and the `anon` key for your app.

**Option B — run it locally.** Needs Docker and the
[Supabase CLI](https://supabase.com/docs/guides/local-development).

```bash
supabase init
supabase start        # prints your URL, keys, and DB URL — keep this output
```

## 2. Load the schema and seed

One command, same for both options:

```bash
cd setup
npm install
node setup.mjs "<your-connection-string>"
```

It applies the schema, applies the seed, and then verifies the result rather than assuming it
worked. You should see:

```
  institutions   2  (Northgate University, Riverside Institute of Technology)
  auth users     13
  profiles       13
  identities     13
```

If you want to start over at any point:

```bash
node setup.mjs "<your-connection-string>" --reset
```

`--reset` only drops the tables this exercise created and the accounts it seeded. It will not
touch anything else in that database. It is safe to re-run as often as you like.

## 3. Sign in

Every seeded account uses the password `TakeHome123!`.

| Email | Institution | Role | Why they're interesting |
|---|---|---|---|
| `ana.reyes@northgate.edu` | Northgate | student | Enrolled in Northgate CS 4780 |
| `ana.reyes@riverside.edu` | Riverside | student | **Same name, different institution** |
| `ben.tanaka@northgate.edu` | Northgate | student | Also in Northgate CS 4780 |
| `eli.forsberg@northgate.edu` | Northgate | student | Right institution, **wrong section** |
| `prof.hale@northgate.edu` | Northgate | professor | Teaches CS 4780 |
| `prof.osei@northgate.edu` | Northgate | professor | Right institution, **teaches a different section** |
| `prof.hale@riverside.edu` | Riverside | professor | Teaches the *other* CS 4780 |
| `admin@northgate.edu` | Northgate | admin | |

The last column is the assignment. Every one of those "wrong" cases is somebody who will end up
seeing something they shouldn't if the boundary is drawn incorrectly, and none of them look
wrong on screen.

## A note on the starting condition

`01-schema.sql` enables row-level security on nothing and defines no policies. Straight after
step 2, any authenticated user can read and write every row in the database, including the
other institution's. That is deliberate — it is where you start, not something we forgot.

## Resetting

`node setup.mjs "<connection-string>" --reset` from the `setup/` folder. Do this freely; there
is nothing precious in here.
