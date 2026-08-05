# Take-Home Assignment: Software Engineer Intern

> **Note:** This repository is for reading the assignment only. Do not push your code here.
> Create your own repository and send us that link.

**Effort: 10–12 hours.** Please don't spend more. We would rather see one thing finished than
five things started.

---

## What you're building

**Team projects for students — in a database that holds two universities at once.**

That second half is the assignment.

One copy of Scholera serves many universities. Every course, message and grade in the database
belongs to exactly one of them. A student at one university must never be able to reach another
university's data. Not through the screen, not through the API, not by guessing an ID, not by
any route at all.

Students work in teams. A team has members and a private chat. That's a simple feature until you
count how many people must **not** see a given message: students at another university,
students in the same university but a different course, students in the same course but a
different team. Meanwhile the professor teaching that section can read it, and an administrator
probably can too.

Every one of those is a chance to leak somebody's private conversation.

**Build the feature. Then prove it's safe.** The second part is what we're actually reading.

---

## Why this is harder than it looks

When this goes wrong, nothing crashes.

There's no error, no stack trace, no red text. The database simply hands the right-looking data
to the wrong person, and everything continues normally. Nobody notices until someone reads a
message they shouldn't have.

That's why "I clicked around and it seemed fine" is not evidence of anything, and why the
interesting half of this assignment is the part where you try to break your own work.

---

## The one rule

**Depth beats breadth.** A small feature that is genuinely airtight beats a large one with a hole
in it. Nobody is scoring how many screens you built.

Keep the interface plain. Unstyled is completely fine — we are not looking at your CSS here.

---

## What we give you

Everything is in `data/`.

```
data/
  SETUP.md        Start here
  01-schema.sql   The tables
  02-seed.sql     Two universities, with accounts you can log in as
  setup/          One command that loads it into your database
```

`SETUP.md` walks you through it. You can use a **free cloud Supabase project** (no Docker
needed, works on a locked-down laptop) or run it locally — the setup command is the same either
way. Every seeded account's password is `TakeHome123!`.

**Read `01-schema.sql` before you start.** It has no security rules in it at all. As shipped,
anyone who can reach that database can read and write every row in it, including the other
university's. That's your starting point, not something we forgot.

The seed data is **deliberately confusing**: the same course code at both universities, two
different students both called Ana Reyes, two professors both called Hale. A leak between them
doesn't look obviously wrong on screen. That's exactly the point — it has to be prevented by the
database, not caught by eye.

The bottom of the seed file lists the accounts worth testing with and why each one is
interesting. That list is more or less the assignment.

---

## What has to be true

1. **It runs.** A stranger clones your repo and reaches a working app in under five minutes,
   using only your README.
2. **Students can do the thing.** A professor creates a project and teams; students see their
   own team and talk in it; the professor can read team chats in their own section.
3. **The database enforces the boundary, not just your code.** Checks in application code are
   necessary and not sufficient — anyone who gets a database credential, or finds a route you
   forgot to guard, walks straight past them. Postgres can refuse to return rows the current
   user shouldn't see. Use that.
4. **You tried to break it, and wrote down what you tried.** Not tests proving the feature works
   when used politely. Tests that *attack* it and confirm the attack fails.

If you haven't written a Postgres security policy before, that's expected — the Supabase docs
cover it well, and learning it is part of the exercise.

---

## Where to put your thinking

The interesting question isn't "did I add the rules." It's **"how would I know if I got one
wrong?"**

Some directions worth considering, none required: what would you attack first if this were
someone else's code? What's the difference between a rule that's wrong and a rule that's missing
entirely — and which is easier to spot? If a teammate added a new table next week, what would
make them do the right thing by default?

We have our own set of attacks that we'll run against whatever you build. You'll get further by
imagining them than by guessing at a checklist.

---

## What we're actually looking at

**Does the boundary hold?** Under a deliberate attempt to cross it, at the database layer.

**Did you attack your own work?** Or only confirm it works when used correctly?

**Judgement.** Where this assignment is vague, did you make a defensible call and say why?

**Craft.** Can someone else read this? Is the security logic in one place, or scattered?

---

## Using AI coding tools

Use them. We do, and we'd find it strange if you didn't. Two conditions:

**One:** keep a short `AI_USAGE.md` — which tools, for which parts, and an honest paragraph on
where they helped and where they led you wrong.

Worth knowing for this one specifically: **AI tools are noticeably worse at security rules than
at ordinary code.** They will confidently write a policy that does not do what it appears to do.
Check every one yourself. If you caught a tool getting one wrong, that's exactly the kind of
thing we want in that file.

**Two:** in the review call you must be able to explain any line in your repository. **Code you
cannot explain is worth less than code you did not write.**

---

## What to send us

1. **A public GitHub repo**, with readable incremental commits. A single "initial commit"
   containing everything gets questioned in the review call.
2. **`README.md`** — setup in under five minutes; who can see what, in plain language, and where
   that's enforced; how to run your tests and what they prove; and anything you know is still
   weak. Limitations you name yourself are never held against you.
3. **`AI_USAGE.md`** — see above.
4. **A video of you presenting the project** — see below.

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

Shortlisted candidates get a 25-minute call: you walk us through your security rules, we ask you
to make one small change while we watch, then your questions for us.

---

## Getting stuck

If something here is ambiguous, that's usually deliberate — make a call and write down why.

If something is actually broken, or setup won't work, reply to the email that sent you this
assignment, or write to **proscio@scholera-inc.com**. That's our problem, and it shouldn't cost you any of your
twelve hours.

**Setup problems are always worth writing about — that's on us.** Please don't decide a question isn't important enough to ask; we would much rather answer it than read a submission quietly compromised by something we could have fixed in five minutes.

---

**If you find a hole in your own work and can't fix it in time, write it up clearly.** That is a
much better outcome than hoping we don't notice, and we will notice. Finding a weakness in your
own system and describing it accurately is most of what this job is.
