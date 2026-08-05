-- Scholera take-home — seed data.
--
-- Creates TWO institutions with deliberately similar-looking data: comparable course codes,
-- comparable names, the same term. If your isolation is wrong, these are the rows that will
-- leak into each other, and the similarity is the point — a bug here does not look obviously
-- wrong on screen.
--
-- Run after 01-schema.sql.
--
-- Every seeded user has the password:  TakeHome123!

-- ── Auth users ───────────────────────────────────────────────────────────────
-- Inserted directly into auth.users so you have real, sign-in-able accounts.
--
-- Works against a local `supabase start` stack or a free cloud project. pgcrypto lives
-- in the extensions schema on hosted Supabase and in public on some local setups, so we
-- put both on the search path rather than qualifying the calls.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
SET search_path = public, extensions;

DO $$
DECLARE
  northgate uuid := '11111111-1111-1111-1111-111111111111';
  riverside uuid := '22222222-2222-2222-2222-222222222222';
  u         record;
BEGIN
  INSERT INTO institutions (id, name) VALUES
    (northgate, 'Northgate University'),
    (riverside, 'Riverside Institute of Technology');

  FOR u IN
    SELECT * FROM (VALUES
      -- Northgate
      ('a0000000-0000-0000-0000-000000000001'::uuid, 'prof.hale@northgate.edu',    'professor', 'Dr. Miriam Hale',    '11111111-1111-1111-1111-111111111111'::uuid),
      ('a0000000-0000-0000-0000-000000000002'::uuid, 'prof.osei@northgate.edu',    'professor', 'Dr. Kwabena Osei',  '11111111-1111-1111-1111-111111111111'::uuid),
      ('a0000000-0000-0000-0000-000000000003'::uuid, 'admin@northgate.edu',        'admin',     'Northgate Admin',   '11111111-1111-1111-1111-111111111111'::uuid),
      ('a0000000-0000-0000-0000-000000000011'::uuid, 'ana.reyes@northgate.edu',    'student',   'Ana Reyes',         '11111111-1111-1111-1111-111111111111'::uuid),
      ('a0000000-0000-0000-0000-000000000012'::uuid, 'ben.tanaka@northgate.edu',   'student',   'Ben Tanaka',        '11111111-1111-1111-1111-111111111111'::uuid),
      ('a0000000-0000-0000-0000-000000000013'::uuid, 'cara.nwosu@northgate.edu',   'student',   'Cara Nwosu',        '11111111-1111-1111-1111-111111111111'::uuid),
      ('a0000000-0000-0000-0000-000000000014'::uuid, 'dev.malhotra@northgate.edu', 'student',   'Dev Malhotra',      '11111111-1111-1111-1111-111111111111'::uuid),
      ('a0000000-0000-0000-0000-000000000015'::uuid, 'eli.forsberg@northgate.edu', 'student',   'Eli Forsberg',      '11111111-1111-1111-1111-111111111111'::uuid),
      -- Riverside. Note the deliberately similar names and course codes.
      ('b0000000-0000-0000-0000-000000000001'::uuid, 'prof.hale@riverside.edu',    'professor', 'Dr. Marion Hale',   '22222222-2222-2222-2222-222222222222'::uuid),
      ('b0000000-0000-0000-0000-000000000002'::uuid, 'admin@riverside.edu',        'admin',     'Riverside Admin',   '22222222-2222-2222-2222-222222222222'::uuid),
      ('b0000000-0000-0000-0000-000000000011'::uuid, 'ana.reyes@riverside.edu',    'student',   'Ana Reyes',         '22222222-2222-2222-2222-222222222222'::uuid),
      ('b0000000-0000-0000-0000-000000000012'::uuid, 'ben.tanaka@riverside.edu',   'student',   'Ben Tanaka',        '22222222-2222-2222-2222-222222222222'::uuid),
      ('b0000000-0000-0000-0000-000000000013'::uuid, 'faye.oduya@riverside.edu',   'student',   'Faye Oduya',        '22222222-2222-2222-2222-222222222222'::uuid)
    ) AS t(id, email, role, full_name, inst)
  LOOP
    -- The token columns take empty strings rather than NULL on purpose: recent GoTrue
    -- versions error on NULL here, and the failure surfaces as a confusing login error
    -- rather than as a seeding problem.
    INSERT INTO auth.users (
      id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at,
      raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new
    ) VALUES (
      u.id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      u.email, crypt('TakeHome123!', gen_salt('bf')),
      now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', ''
    );

    -- Without an identity row, password sign-in misbehaves on current Supabase.
    INSERT INTO auth.identities (
      provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at
    ) VALUES (
      u.id::text, u.id,
      jsonb_build_object('sub', u.id::text, 'email', u.email, 'email_verified', true),
      'email', now(), now(), now()
    );

    INSERT INTO profiles (id, institution_id, role, full_name, email)
    VALUES (u.id, u.inst, u.role, u.full_name, u.email);
  END LOOP;
END $$;

-- ── Courses and sections ─────────────────────────────────────────────────────
INSERT INTO courses (id, institution_id, code, title) VALUES
  ('c0000000-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'CS 4780', 'Machine Learning for Engineers'),
  ('c0000000-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'CS 3300', 'Databases'),
  -- Same course code, different institution. On screen these are indistinguishable.
  ('c0000000-0000-0000-0000-000000000003', '22222222-2222-2222-2222-222222222222', 'CS 4780', 'Machine Learning for Engineers');

INSERT INTO sections (id, institution_id, course_id, professor_id, term) VALUES
  ('d0000000-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'c0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001', 'Fall 2026'),
  ('d0000000-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'c0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000002', 'Fall 2026'),
  ('d0000000-0000-0000-0000-000000000003', '22222222-2222-2222-2222-222222222222', 'c0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000001', 'Fall 2026');

INSERT INTO enrollments (institution_id, section_id, student_id) VALUES
  -- Northgate CS 4780
  ('11111111-1111-1111-1111-111111111111', 'd0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000011'),
  ('11111111-1111-1111-1111-111111111111', 'd0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000012'),
  ('11111111-1111-1111-1111-111111111111', 'd0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000013'),
  ('11111111-1111-1111-1111-111111111111', 'd0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000014'),
  -- Northgate CS 3300 — Eli is in this one only. A student in the institution but not the section.
  ('11111111-1111-1111-1111-111111111111', 'd0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000015'),
  -- Riverside CS 4780
  ('22222222-2222-2222-2222-222222222222', 'd0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000011'),
  ('22222222-2222-2222-2222-222222222222', 'd0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000012'),
  ('22222222-2222-2222-2222-222222222222', 'd0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000013');

-- Projects, teams and messages are intentionally NOT seeded. Creating them is part of
-- the feature you are building.
--
-- The interesting people to test with:
--   ana.reyes@northgate.edu   and  ana.reyes@riverside.edu   — same name, different institutions
--   eli.forsberg@northgate.edu — same institution as the CS 4780 team, but not in that section
--   prof.osei@northgate.edu    — a professor at the right institution who teaches a different section
