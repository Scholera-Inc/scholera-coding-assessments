# Take-Home Assignment: AI/ML Research Intern

> **Note:** This assignment produces written work, not a product. Make a repository for your
> deliverables and send us that link.

**Effort: 10–12 hours.** Please don't spend more. Two parts done carefully beats three done
thinly.

---

## What you're doing

**Deciding which of three things we should ship — and being right for reasons you can show
someone.**

Scholera can generate quiz questions from a professor's own lecture slides. There are many ways
to build that. We tried three. Somebody has to decide which one ships, and *"the third one's
answers looked better to me"* is not good enough when thirty thousand students will see the
result.

That decision is the job. This is a small version of it.

---

## Why this is harder than it looks

Everyone in AI is shipping fast and claiming a lot. Most of the claims are made from a handful
of examples that someone eyeballed and liked.

The failure mode isn't being wrong. It's being **confidently** wrong, in a way that sounds
rigorous, so a team builds a roadmap on top of it. Numbers make people stop asking questions,
which is exactly why putting a number on something you haven't actually measured is worse than
saying nothing.

So the skill here isn't producing an answer. It's knowing how much your answer is worth, and
saying so plainly — including when the honest answer is "this data can't tell us."

---

## The one rule

**Say what your evidence supports, and no more than that.**

A recommendation that outruns its evidence is worse than no recommendation, because somebody
will act on it. "I don't have enough here to call it" is a legitimate, valuable finding — as
long as you say what *would* settle it.

---

## What we give you

Everything is in `data/`.

```
data/
  lecture.json          The source material the questions came from
  question-sets.json    Three sets of generated questions, one per strategy
  study-results.md      A write-up from a small internal trial
```

**`lecture.json`** is one week of a machine learning course as a slide deck — bullets, the
professor's speaker notes, LaTeX formulas, and figures described in words.

**`question-sets.json`** holds questions generated from it three ways:

- **Strategy A** put the whole lecture into the model's context and asked for questions
- **Strategy B** retrieved relevant passages first and generated from those
- **Strategy C** generated questions, then made a second pass asking the model to check each one
  against the source and throw away what it couldn't support

You're told which set came from which strategy. You're **not** told which is best, and we don't
assume we know. The sets aren't all the same size — that's a real property of the strategies,
and what you make of it is part of the question.

**`study-results.md`** is a genuine-shaped internal write-up: a summary someone posted to the
team channel after a four-week trial, including their own proposed next step. It has not been
cleaned up for you.

---

## What to produce

### Part 1 — Work out which strategy is best

Decide what "better" means for a generated quiz question, then measure it.

Most of the useful work happens before you score anything. What actually matters — is the
question answerable from the lecture? Is it at a sensible difficulty? Is it trivially guessable?
Does it test understanding or just recall? How do you score that without fooling yourself, given
you're one person with an opinion?

Then run it, and tell us which you'd ship, how confident you are, and what would change your
mind.

Put your scoring sheet in the repo. **We're at least as interested in your method as your
conclusion.**

### Part 2 — Read the internal study and write back

Read `study-results.md` and write a short memo to the team: what does this support, what does it
not, and what would you do next?

Assume the reader is going to act on what you write.

### Part 3 — Look at two competitors *(keep this short, about a page)*

Pick two products in the AI-education space. Use them if you can; read what they publish if you
can't.

For each: what does it genuinely do well, and where is the marketing ahead of the software? Then
one paragraph on what, if anything, Scholera should do differently.

**Being unimpressed is a perfectly good conclusion** if you can support it.

---

## What we're actually looking at

**Do you know what your data can and cannot support?** This is the whole job.

**Can you write?** Your research is worth exactly what a busy reader can get from it in one
pass. We're reading for clarity, not vocabulary.

**Are your recommendations actionable?** "More research is needed" is sometimes right, but only
useful if you say what research and what it would settle.

**Are you honest when the answer is boring?** Sometimes three things are indistinguishable. If
that's what you find, say so, and tell us what you'd need to tell them apart.

## What we're not looking at

- **Length.** A tight four pages beats a padded fifteen.
- **Agreeing with us.** We don't have a predetermined answer. Telling us something we didn't
  expect is a good outcome.
- **Fancy statistics.** Correct simple analysis beats an inappropriate advanced one.
- **Code.** Use a spreadsheet if you like. Anything you write isn't scored.

---

## Using AI tools

Use them, including for the analysis and the writing. We do.

Add a short `AI_USAGE.md` — which tools, for what, and an honest paragraph on where they helped
and where they led you wrong.

One caution that matters here: **a language model asked to judge writing will give you a
confident, plausible, frequently unreliable answer.** If you used one to help score Part 1, say
how you checked it. If you decided not to, say why. Either can be right; not having thought
about it is the problem.

---

## What to send us

1. **A repository** with your deliverables.
2. **`README.md`** — what's here and what you concluded.
3. **Part 1** — your scoring method, your scores, your write-up.
4. **Part 2** — the memo.
5. **Part 3** — the competitor read.
6. **`AI_USAGE.md`** — see above.
7. **A video of you presenting the work** — see below.

Send the repo link to **proscio@scholera-inc.com**, or reply to the email that sent you this assignment.

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

Shortlisted candidates get a 25-minute call. We'll push back on some of your scoring and see
whether you hold your position or update it — **both are correct answers**, and what we're
watching is whether the reasoning is load-bearing. We'll also give you something new to score
with your own method, live.

---

## Getting stuck

If something here is ambiguous, that's usually deliberate — make a call and write down why.

---

**The most valuable thing a researcher does is tell the team something they didn't want to hear,
early, with evidence.** If your analysis undercuts a premise in this assignment, write that
down. It's the outcome we'd be most impressed by.
