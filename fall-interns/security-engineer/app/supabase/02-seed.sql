-- Coursely — seed data. Two institutions, real accounts.
-- Every account's password is:  TakeHome123!
--
-- Works against a local `supabase start` stack or a free cloud project. pgcrypto lives in
-- the extensions schema on hosted Supabase and in public on some local setups, so we put
-- both on the search path rather than qualifying the calls.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
SET search_path = public, extensions;

DO $$
DECLARE
  meridian uuid := '11111111-1111-1111-1111-111111111111';
  lakeside uuid := '22222222-2222-2222-2222-222222222222';
  u record;
BEGIN
  INSERT INTO institutions (id, name) VALUES
    (meridian, 'Meridian College'),
    (lakeside, 'Lakeside Polytechnic');

  FOR u IN SELECT * FROM (VALUES
    ('a0000000-0000-0000-0000-000000000001'::uuid, 'prof@meridian.edu',    'professor', 'Dr. Ruth Adeyemi', '11111111-1111-1111-1111-111111111111'::uuid),
    ('a0000000-0000-0000-0000-000000000002'::uuid, 'admin@meridian.edu',   'admin',     'Meridian Admin',   '11111111-1111-1111-1111-111111111111'::uuid),
    ('a0000000-0000-0000-0000-000000000011'::uuid, 'sam@meridian.edu',     'student',   'Sam Whitfield',    '11111111-1111-1111-1111-111111111111'::uuid),
    ('a0000000-0000-0000-0000-000000000012'::uuid, 'juno@meridian.edu',    'student',   'Juno Park',        '11111111-1111-1111-1111-111111111111'::uuid),
    ('b0000000-0000-0000-0000-000000000001'::uuid, 'prof@lakeside.edu',    'professor', 'Dr. Owen Brady',   '22222222-2222-2222-2222-222222222222'::uuid),
    ('b0000000-0000-0000-0000-000000000011'::uuid, 'iris@lakeside.edu',    'student',   'Iris Kaur',        '22222222-2222-2222-2222-222222222222'::uuid)
  ) AS t(id, email, role, full_name, inst)
  LOOP
    -- Empty strings rather than NULL in the token columns: recent GoTrue versions error
    -- on NULL, and it surfaces as a confusing login failure rather than a seeding one.
    INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password,
      email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data,
      confirmation_token, recovery_token, email_change, email_change_token_new)
    VALUES (u.id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
      u.email, crypt('TakeHome123!', gen_salt('bf')), now(), now(), now(),
      '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
      '', '', '', '');

    -- Without an identity row, password sign-in misbehaves on current Supabase.
    INSERT INTO auth.identities (provider_id, user_id, identity_data, provider,
      last_sign_in_at, created_at, updated_at)
    VALUES (u.id::text, u.id,
      jsonb_build_object('sub', u.id::text, 'email', u.email, 'email_verified', true),
      'email', now(), now(), now());

    INSERT INTO profiles (id, institution_id, role, full_name, email)
    VALUES (u.id, u.inst, u.role, u.full_name, u.email);
  END LOOP;
END $$;

INSERT INTO sections (id, institution_id, professor_id, code, title) VALUES
  ('d0000000-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'a0000000-0000-0000-0000-000000000001', 'BIO 210', 'Cell Biology'),
  ('d0000000-0000-0000-0000-000000000002', '22222222-2222-2222-2222-222222222222', 'b0000000-0000-0000-0000-000000000001', 'BIO 210', 'Cell Biology');

INSERT INTO enrollments (institution_id, section_id, student_id) VALUES
  ('11111111-1111-1111-1111-111111111111', 'd0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000011'),
  ('11111111-1111-1111-1111-111111111111', 'd0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000012'),
  ('22222222-2222-2222-2222-222222222222', 'd0000000-0000-0000-0000-000000000002', 'b0000000-0000-0000-0000-000000000011');

INSERT INTO announcements (institution_id, section_id, author_id, title, body) VALUES
  ('11111111-1111-1111-1111-111111111111', 'd0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001',
   'Midterm moved', '<p>The midterm is now on the <strong>14th</strong>. Room unchanged.</p>'),
  ('22222222-2222-2222-2222-222222222222', 'd0000000-0000-0000-0000-000000000002', 'b0000000-0000-0000-0000-000000000001',
   'Lab groups posted', '<p>Check the noticeboard for your group assignment.</p>');

INSERT INTO submissions (id, institution_id, section_id, student_id, content, grade, feedback) VALUES
  ('e0000000-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'd0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000011',
   'Mitochondria generate ATP through oxidative phosphorylation...', 84, 'Good detail on the electron transport chain.'),
  ('e0000000-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'd0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000012',
   'The cell membrane is a phospholipid bilayer...', 61, 'Thin. See me in office hours.'),
  -- Belongs to the OTHER institution. Nobody at Meridian should ever see this row.
  ('e0000000-0000-0000-0000-000000000003', '22222222-2222-2222-2222-222222222222', 'd0000000-0000-0000-0000-000000000002', 'b0000000-0000-0000-0000-000000000011',
   'Osmosis is the movement of water across a semipermeable membrane...', 92, 'Excellent.');

INSERT INTO private_notes (institution_id, author_id, subject_id, body) VALUES
  ('11111111-1111-1111-1111-111111111111', 'a0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000012',
   'Juno disclosed a family bereavement and has requested an extension. Handle discreetly.'),
  ('22222222-2222-2222-2222-222222222222', 'b0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000011',
   'Iris is under academic review following a suspected plagiarism referral.');
