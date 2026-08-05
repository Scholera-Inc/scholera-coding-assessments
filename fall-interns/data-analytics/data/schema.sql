-- Schema for the Scholera analytics exercise.
--
-- This mirrors the shapes the platform uses in production. The events table is the
-- important one: the platform writes a row here for essentially everything that happens,
-- and most of the interesting questions are answered by joining it back to the
-- relational tables below.

CREATE TABLE departments (
  id             TEXT PRIMARY KEY,
  institution_id TEXT NOT NULL,
  name           TEXT NOT NULL
);

CREATE TABLE professors (
  id            TEXT PRIMARY KEY,
  department_id TEXT NOT NULL REFERENCES departments(id),
  name          TEXT NOT NULL
);

CREATE TABLE students (
  id            TEXT PRIMARY KEY,
  department_id TEXT NOT NULL REFERENCES departments(id),
  name          TEXT NOT NULL,
  status        TEXT NOT NULL          -- active | withdrawn
);

CREATE TABLE sections (
  id             TEXT PRIMARY KEY,
  institution_id TEXT NOT NULL,
  department_id  TEXT NOT NULL REFERENCES departments(id),
  professor_id   TEXT NOT NULL REFERENCES professors(id),
  code           TEXT NOT NULL,
  title          TEXT NOT NULL
);

CREATE TABLE enrollments (
  id         TEXT PRIMARY KEY,
  section_id TEXT NOT NULL REFERENCES sections(id),
  student_id TEXT NOT NULL REFERENCES students(id),
  status     TEXT NOT NULL
);

CREATE TABLE assignments (
  id              TEXT PRIMARY KEY,
  section_id      TEXT NOT NULL REFERENCES sections(id),
  title           TEXT NOT NULL,
  points_possible INTEGER NOT NULL,
  published_at    TEXT NOT NULL,
  due_at          TEXT NOT NULL
);

CREATE TABLE submissions (
  id            TEXT PRIMARY KEY,
  assignment_id TEXT NOT NULL REFERENCES assignments(id),
  student_id    TEXT NOT NULL REFERENCES students(id),
  section_id    TEXT NOT NULL REFERENCES sections(id),
  submitted_at  TEXT NOT NULL
);

CREATE TABLE grades (
  id            TEXT PRIMARY KEY,
  assignment_id TEXT NOT NULL REFERENCES assignments(id),
  student_id    TEXT NOT NULL REFERENCES students(id),
  score         INTEGER NOT NULL,
  released_at   TEXT NOT NULL
);

-- One row per thing that happened. actor_id is whoever caused it (a professor or a
-- student); entity_type/entity_id point at what it happened to.
CREATE TABLE events (
  id             TEXT PRIMARY KEY,
  institution_id TEXT NOT NULL,
  section_id     TEXT,
  event_type     TEXT NOT NULL,
  actor_id       TEXT,
  entity_type    TEXT,
  entity_id      TEXT,
  created_at     TEXT NOT NULL
);

CREATE INDEX idx_events_type    ON events(event_type);
CREATE INDEX idx_events_section ON events(section_id);
CREATE INDEX idx_events_actor   ON events(actor_id);
CREATE INDEX idx_events_created ON events(created_at);
CREATE INDEX idx_sub_assignment ON submissions(assignment_id);
CREATE INDEX idx_enr_section    ON enrollments(section_id);
