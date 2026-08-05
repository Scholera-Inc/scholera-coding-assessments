# Take-Home Assignment: Data Analytics Intern

> **Note:** This repository is for reading the assignment only. Do not push your work here.
> Create your own repository and send us that link.

**Effort: 10–12 hours.** Please don't spend more. Two questions answered properly beats four
answered thinly.

---

## What you're doing

**Taking a semester of real-shaped data and telling us something true about it.**

Scholera records an event for essentially everything that happens inside it — a module
published, an assignment submitted, a quiz started, a grade released. Together those events are
an unusually complete picture of how a course actually ran, rather than how the syllabus said it
would.

We use a fraction of it.

The people who buy Scholera are university administrators. What they want to know is whether
their faculty actually used the thing they paid for, and whether their students are doing any
better. Those are answerable questions. Somebody should be answering them clearly.

---

## Why this is harder than it looks

Every dataset contains differences. Most of them mean nothing.

A number with a story attached is very persuasive, and persuasive is dangerous when it's wrong.
A confident finding that doesn't hold up doesn't just waste time — it sends a roadmap in the
wrong direction, and by the time anyone notices, three decisions have been built on top of it.

So the skill isn't producing numbers. It's knowing **which of your numbers you'd actually stake
a decision on**, and saying plainly when the answer is "not this one."

---

## The one rule

**Say what your data supports, and no more than that.**

If a result looks exciting and won't hold weight, saying so is a *good* answer, not a failure to
find something. Just tell us what it would take to know for sure.

---

## What we give you

Everything is in `data/`. One semester at a mid-sized university: five departments, forty course
sections, 1,400 students, around 13,000 events.

```
data/
  scholera.db     SQLite — everything already loaded. Start here.
  schema.sql      The table definitions, commented
  *.csv           The same data as flat files, if you prefer pandas or R
```

The SQLite file needs no setup and no server:

```bash
sqlite3 data/scholera.db "SELECT COUNT(*) FROM events;"
```

Any language with a SQLite binding opens it directly. The CSVs are identical data — use whatever
suits you.

The `events` table is the important one: what happened, who caused it, what it happened to, and
when. Most of the interesting questions come from joining it back to the other tables.

**The data is realistic, which means it is not tidy.** It has the gaps, duplicates and oddities
that real event logs have, because the production data you'd be working with has them too.
Noticing them is part of the work — a number that quietly depends on *not* having noticed is
worse than no number.

---

## What to produce

### 1. Answer three questions with SQL

**Did the faculty actually use it?** Which features do professors use, and how does that differ
between departments? A professor who logs in weekly and posts announcements is using a fraction
of what their university paid for. Is that happening, and is it concentrated anywhere?

**Where do students fall out?** Take the path from an assignment being published to a grade
being released. Students drop out of it. Where, how many, and does it differ by course, by type
of assignment, or by when in the term it happened?

**Can we spot trouble early?** Can you identify students likely to do badly, early enough for
someone to do something about it? You define what "badly" means and how early is early enough —
and be straight with us about how well your signal actually works, including how often it would
flag someone who was fine.

Include your SQL. We'll read it, and we'll run some of our own against the same data.

### 2. Build one screen

Pick the single most useful view for a university administrator and build it.

They have about thirty seconds and they will not study anything. A screen that needs explaining
has failed. **Choosing what to leave off is most of the work.**

React with a charting library is closest to how we build, but use whatever gets you to something
real and working. A static mockup doesn't count — we want to see it rendering from the actual
data.

### 3. Write the recommendation

Two pages maximum, for someone who will act on it. What did you find, what should we do, and how
confident are you? Where the data won't support a firm answer, say so and say what would settle
it.

---

## Where to put your thinking

The three questions above are a floor, not a ceiling. If while you're in there you find
something more interesting than what we asked for, **follow it** — and tell us why it mattered
more.

Some directions, none required: what does a course that's going well look like in event data,
versus one that isn't? Is there a moment in the term where everything changes? What would you
want to measure that this data *can't* tell you, and what would you need to collect?

---

## What we're actually looking at

**Is the SQL right?** Fairly literally — do your numbers survive us running our own queries?
Joins across event logs are easy to get subtly wrong in ways that still look plausible.

**Do you know which findings are real?** We read closely for whether you can tell a result worth
acting on from one that only looks that way, and whether you say so.

**Is the screen usable in thirty seconds?** By someone who didn't build it and won't ask.

**Does the analysis become a decision?** A chart that doesn't tell anyone what to do isn't
finished.

## What we're not looking at

- **Tools.** Python, R, or straight SQL — all fine.
- **Visual polish** beyond being legible. Clear beats pretty.
- **Model sophistication.** A well-reasoned threshold beats a badly validated classifier. We'd
  rather see you justify something simple.

---

## A note on the data

It's synthetic and contains no real students. In the actual job you'd be working with real
student records under access controls and legal obligations we take seriously, and we'll talk
about that in the interview.

---

## Using AI tools

Use them, including for the SQL. We do.

Add a short `AI_USAGE.md` — which tools, for what, and an honest paragraph on where they helped
and where they led you wrong.

Relevant here: **models write confident SQL that is quietly wrong on joins and aggregation**, and
the result looks entirely reasonable. Catching a query that ran cleanly and returned the wrong
answer is exactly the skill this job is built on — so if it happens, tell us about it.

---

## What to send us

1. **A repository** with your work.
2. **`README.md`** — what's here, how to run it, what you concluded.
3. **Your SQL**, runnable, with comments on anything non-obvious.
4. **The screen**, with setup instructions.
5. **Your recommendation.**
6. **`AI_USAGE.md`** — see above.
7. **A video of you presenting the project** — see below.

Send the repo link to **proscio@scholera-inc.com**, or reply to the email that sent you this assignment.
Check the video opens in a private browser window.

**Deadline: 14 August 2026, 23:59 IST.** Later commits are ignored, so if you finish early just send it.

---

## The video — please take this seriously

Every candidate records one, whatever role they applied for. It is the fastest way for us to
understand not just what you built but how you think about it, and it is the part of your
submission we spend the most time with.

**Length: 5–8 minutes.** Unlisted link — Loom, an unlisted YouTube video, Drive, anything.
**Open it in a private browser window and check it plays** before you send it. A link we can't
open is the single most common reason a good submission stalls.

**Please appear on camera**, at least to introduce yourself. We are not scoring presentation
skills or production value — a webcam and a screen recording is exactly right, and a rough
single take is completely fine. We would simply rather meet you than watch an anonymous screen.

### What to cover

In whatever order suits your project:

1. **Who you are.** Thirty seconds. Your name, where you're studying, what you're interested in.
2. **What you built, and why that.** The assignment deliberately left room for choices. Tell us
   the ones you made and the reasoning behind them.
3. **Show it actually working.** A real walkthrough of the running thing, not slides and not a
   tour of your source files.
4. **Show something that isn't perfect.** An edge case, an error state, a corner you didn't
   finish. Every real project has them, and we trust a demo more when it includes one.
5. **The hardest decision you made.** What you were choosing between, what you picked, and what
   you gave up to get it.
6. **Where the AI tools helped, and where they were wrong.** Same ground as your `AI_USAGE.md`,
   but say it out loud — the specific thing a tool got wrong and how you caught it.
7. **What you'd do next** with another week, and why that would be the right next thing.

### What we're listening for

Whether you understand your own work. Whether you can explain a technical decision to someone
who wasn't in your head when you made it. Whether you know where your project is weak.

**Being honest about a limitation always reads better than glossing over it.** If something is
broken, show us and tell us why — a candidate who says "this falls over on long inputs and here
is what I'd change" is telling us far more than one whose demo only ever walks the happy path.

Don't script it word for word. We would rather hear you think.
---

## The review call

Shortlisted candidates get a 25-minute call. We'll go through your queries, ask why you joined
something a particular way, and give you a new question to write a query for while we watch. It
won't be a hard one.

---

## Getting stuck

If something here is ambiguous, that's usually deliberate — make a call and write down why.

If the data won't load, reply to the email that sent you this assignment, or write to
**proscio@scholera-inc.com**. That's our problem.

**Setup problems are always worth writing about — that's on us.** Please don't decide a question isn't important enough to ask; we would much rather answer it than read a submission quietly compromised by something we could have fixed in five minutes.

---

**The most useful thing an analyst does is say "that's not a real result" before anyone builds a
plan around it.** If the honest answer to one of these questions is that the data can't support a
conclusion, write that down and show why. That's a strong submission, not a weak one.
