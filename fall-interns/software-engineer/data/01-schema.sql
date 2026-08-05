-- Scholera take-home — base schema.
--
-- These are the shapes the real platform uses, trimmed to what this exercise needs.
-- Note what is NOT here: there is not a single row-level security policy in this file, and
-- RLS is not enabled on any table. Every table below is currently readable and writable by
-- anyone who can reach the database. Fixing that is your job.
--
-- Run this first, then 02-seed.sql.

-- ── Tenancy ──────────────────────────────────────────────────────────────────
-- Every tenant-scoped row carries institution_id. This is the boundary.

CREATE TABLE institutions (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name       text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- One row per user, keyed to Supabase auth.
CREATE TABLE profiles (
  id             uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  institution_id uuid NOT NULL REFERENCES institutions(id),
  role           text NOT NULL CHECK (role IN ('admin', 'professor', 'student')),
  full_name      text NOT NULL,
  email          text NOT NULL,
  created_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE courses (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  code           text NOT NULL,
  title          text NOT NULL
);

CREATE TABLE sections (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  course_id      uuid NOT NULL REFERENCES courses(id),
  professor_id   uuid NOT NULL REFERENCES profiles(id),
  term           text NOT NULL
);

CREATE TABLE enrollments (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  section_id     uuid NOT NULL REFERENCES sections(id),
  student_id     uuid NOT NULL REFERENCES profiles(id),
  UNIQUE (section_id, student_id)
);

-- ── What you are building ────────────────────────────────────────────────────
-- These four tables are the feature. They are deliberately minimal; add columns if
-- your design needs them, and say why in your README.

CREATE TABLE projects (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  section_id     uuid NOT NULL REFERENCES sections(id),
  title          text NOT NULL,
  created_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE teams (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  project_id     uuid NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  name           text NOT NULL
);

CREATE TABLE team_members (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  team_id        uuid NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
  student_id     uuid NOT NULL REFERENCES profiles(id),
  UNIQUE (team_id, student_id)
);

CREATE TABLE team_messages (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  team_id        uuid NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
  author_id      uuid NOT NULL REFERENCES profiles(id),
  body           text NOT NULL,
  created_at     timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_team_messages_team ON team_messages(team_id, created_at);
CREATE INDEX idx_team_members_team  ON team_members(team_id);
CREATE INDEX idx_enrollments_section ON enrollments(section_id);
