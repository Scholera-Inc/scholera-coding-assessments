# Take-Home Assignment: Security Engineer Intern

> **Note:** Everything here happens against the practice app we give you. Do not test against
> any Scholera system, any live site, or any target you haven't been explicitly authorised for.
> Make your own repository for your write-up.

**Effort: 10–12 hours.** Please don't spend more. A few findings written up properly beats a
long list of maybes.

---

## What you're doing

**Breaking a small app we built badly on purpose — and then explaining it well enough that
someone could fix it.**

The app is called Coursely. It's a course platform for universities: two of them, sharing one
database, with professors and students at each. We've left a number of security flaws in it.

Find them.

We're not telling you how many, and they are not all equally loud. **At least one won't turn up
by clicking around.**

---

## Why this is harder than it looks

Broken access control is the most common serious flaw in software shaped like this, and it's
boring in a specific way: it rarely looks like an exploit.

It looks like a route that forgot a check. A rule that says "allow everyone." A function anyone
can call. Nothing crashes, no alert fires, and the system politely returns correct-looking data
to entirely the wrong person.

Scanners find some of this. The rest needs somebody who understands what the app is *supposed*
to do and notices where it doesn't.

That's the job, and it's why **finding a flaw is the cheap part of this assignment.** Proving
it, judging how bad it really is, and knowing what would have caught it in production — that's
the part we're reading.

---

## The one rule

**A finding we can't reproduce from your write-up is not a finding.**

Five real ones, clearly explained, beat thirty with twenty-five false positives. A long list of
unverified maybes counts against you, because on a real team every one of them costs somebody a
day.

---

## What we give you

The app is in `app/`. Full source, including the database rules.

```
app/
  README.md            setup, and the accounts you can log in as
  supabase/            the database: tables, security rules, seed data
    setup/             one command that loads it into your database
  src/                 pages, server actions, components
```

`app/README.md` walks you through setup. You can use a **free cloud Supabase project** (no
Docker, works on a locked-down laptop) or run it locally.

You get **accounts at both universities, at every role**. That's deliberate. The most
interesting question you can ask this app is what someone at one university can reach at the
other.

Two things worth saying plainly:

- The database contains records that would genuinely hurt someone if they leaked. That's
  realistic, and it's there so that judging impact means something.
- **Not everything in this app is reachable from the screen.** Reading the SQL is not optional.

> **If you use a cloud project:** make one solely for this exercise and delete it afterwards.
> You're going to be attacking it. Don't point it at anything real.

---

## What to produce

### 1. Find what's wrong

Read the code, use the app, attack it. However you like — reading source, poking it from a
logged-in session, intercepting requests, calling the API directly, querying the database as
different users.

Things worth thinking about in an app like this: what happens when someone asks for a record
belonging to somebody else by ID; what the database hands to a client that skips the screen
entirely; what runs with elevated privileges and who's allowed to trigger it; what gets rendered
without escaping; what ends up in the JavaScript that shouldn't.

**That's a starting point, not a checklist. Some of what's in there isn't on it.**

### 2. Write it up

For each finding: what it is, where, **steps precise enough that we can follow them and see it
ourselves**, what an attacker actually gets, how serious it is and why, and how you'd fix it.

Be specific and realistic about impact. We'd rather you under-claim than inflate.

### 3. Fix two

Pick the two you think are worst and fix them properly. Send the patch or a branch, with a note
on why your fix closes the hole rather than moving it.

### 4. Say how we'd have known

For each finding, answer a separate question: **what signal would have told us this was being
exploited?**

Our real app logs in a structured way but has no alerting on top of it. What would you record,
what pattern would mean abuse rather than normal use, and what deserves waking someone at 2am?

Tell us what you'd deliberately **not** alert on, too. An alert nobody trusts is worse than no
alert.

---

## A hard rule

**Test only the practice app.** Not Scholera's production systems, our website, our cloud
infrastructure, or any third-party service. Not at any point, for any reason.

We will ask about scope and authorisation in the review call. Getting this right matters more to
us than any finding you could report, and someone who tested outside scope isn't hireable
regardless of what they found.

If you're unsure whether something is in scope, **ask us at proscio@scholera-inc.com**. That's the one question in
this assignment we won't tell you to answer yourself.

---

## What we're actually looking at

**Coverage** — did you find the quiet ones, or only what a scanner would surface?

**Reproducibility** — can we follow your steps and see it?

**Judgement** — is severity assessed realistically, or is everything Critical?

**Detection thinking** — do you understand what would have caught this in production?

**Scope discipline** — did you stay inside the boundary you were given?

## What we're not looking at

- **Tools.** Burp, ZAP, curl, or nothing but your eyes — all fine.
- **Volume.** See the one rule.
- **Completeness.** Nobody is expected to find everything.

---

## Using AI tools

Use them. We do.

Add a short `AI_USAGE.md` — which tools, for what, and an honest paragraph on where they helped
and where they led you wrong.

Relevant here: models are decent at spotting suspicious patterns in code and **unreliable at
judging whether a specific one is actually exploitable**. They produce confident false positives.
A tool flagging something you then disproved — and how you disproved it — is one of the more
useful things you can show us.

In the review call you must be able to explain your own findings. **A finding you can't
reproduce on demand counts against you.**

---

## What to send us

1. **A repository** with your write-up.
2. **`FINDINGS.md`** — section 2, most serious first.
3. **`DETECTION.md`** — section 4.
4. **Your fixes**, as a patch or branch.
5. **`AI_USAGE.md`** — see above.
6. **A video of you presenting the project** — see below.

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

Shortlisted candidates get a 25-minute call. We'll stand up a fresh copy of the app and ask you
to demonstrate one of your findings live, then talk through how you'd have detected it.

---

## Getting stuck

If setup won't work, reply to the email that sent you this assignment, or write to **proscio@scholera-inc.com** —
that's our problem, not part of the test.

**Setup problems are always worth writing about — that's on us.** Please don't decide a question isn't important enough to ask; we would much rather answer it than read a submission quietly compromised by something we could have fixed in five minutes.

If something in this document is ambiguous, that's usually deliberate — make a call and write
down why. **Except anything about scope. On scope, ask.**

---

**If you suspect something is a flaw but couldn't prove it, say exactly that and show how far
you got.** Reporting a hunch as a confirmed finding is the one habit that makes a security
engineer impossible to work with, because everything else they say has to be re-checked.
