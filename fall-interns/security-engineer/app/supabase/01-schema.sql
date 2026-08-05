-- Coursely — schema.
--
-- Multi-tenant: every tenant-scoped row carries institution_id, and no user should ever
-- be able to reach a row belonging to another institution.

CREATE TABLE institutions (
  id   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL
);

CREATE TABLE profiles (
  id             uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  institution_id uuid NOT NULL REFERENCES institutions(id),
  role           text NOT NULL CHECK (role IN ('admin', 'professor', 'student')),
  full_name      text NOT NULL,
  email          text NOT NULL
);

CREATE TABLE sections (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  professor_id   uuid NOT NULL REFERENCES profiles(id),
  code           text NOT NULL,
  title          text NOT NULL
);

CREATE TABLE enrollments (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  section_id     uuid NOT NULL REFERENCES sections(id),
  student_id     uuid NOT NULL REFERENCES profiles(id)
);

CREATE TABLE announcements (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  section_id     uuid NOT NULL REFERENCES sections(id),
  author_id      uuid NOT NULL REFERENCES profiles(id),
  title          text NOT NULL,
  body           text NOT NULL,
  created_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE submissions (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  section_id     uuid NOT NULL REFERENCES sections(id),
  student_id     uuid NOT NULL REFERENCES profiles(id),
  content        text NOT NULL,
  grade          integer,
  feedback       text,
  created_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE private_notes (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  institution_id uuid NOT NULL REFERENCES institutions(id),
  author_id      uuid NOT NULL REFERENCES profiles(id),
  subject_id     uuid NOT NULL REFERENCES profiles(id),
  body           text NOT NULL
);

-- ── Row level security ───────────────────────────────────────────────────────

ALTER TABLE institutions  ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles      ENABLE ROW LEVEL SECURITY;
ALTER TABLE sections      ENABLE ROW LEVEL SECURITY;
ALTER TABLE enrollments   ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions   ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION current_institution()
RETURNS uuid LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT institution_id FROM profiles WHERE id = auth.uid();
$$;

CREATE POLICY inst_read ON institutions FOR SELECT TO authenticated
  USING (id = current_institution());

CREATE POLICY profiles_read ON profiles FOR SELECT TO authenticated
  USING (institution_id = current_institution());

CREATE POLICY sections_read ON sections FOR SELECT TO authenticated
  USING (institution_id = current_institution());

CREATE POLICY enrollments_read ON enrollments FOR SELECT TO authenticated
  USING (institution_id = current_institution());

CREATE POLICY announcements_read ON announcements FOR SELECT TO authenticated
  USING (institution_id = current_institution());

CREATE POLICY announcements_write ON announcements FOR INSERT TO authenticated
  WITH CHECK (institution_id = current_institution());

CREATE POLICY submissions_read ON submissions FOR SELECT TO authenticated
  USING (
    institution_id = current_institution()
    AND (
      student_id = auth.uid()
      OR EXISTS (
        SELECT 1 FROM sections s
        WHERE s.id = submissions.section_id AND s.professor_id = auth.uid()
      )
    )
  );

CREATE POLICY submissions_insert ON submissions FOR INSERT TO authenticated
  WITH CHECK (institution_id = current_institution() AND student_id = auth.uid());

-- ── Reporting helpers ────────────────────────────────────────────────────────
-- Convenience functions used by the admin dashboard. These need to read across a few
-- tables, so they run as definer to keep the policy logic in one place.

CREATE OR REPLACE FUNCTION section_summary(p_section_id uuid)
RETURNS TABLE (student_name text, submission_count bigint, average_grade numeric)
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT p.full_name, COUNT(sub.id), AVG(sub.grade)
  FROM submissions sub
  JOIN profiles p ON p.id = sub.student_id
  WHERE sub.section_id = p_section_id
  GROUP BY p.full_name;
$$;

REVOKE EXECUTE ON FUNCTION section_summary(uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION section_summary(uuid) TO authenticated;

CREATE OR REPLACE FUNCTION institution_roster(p_institution_id uuid)
RETURNS TABLE (id uuid, full_name text, email text, role text)
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT id, full_name, email, role FROM profiles WHERE institution_id = p_institution_id;
$$;

REVOKE EXECUTE ON FUNCTION institution_roster(uuid) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION institution_roster(uuid) TO authenticated;
