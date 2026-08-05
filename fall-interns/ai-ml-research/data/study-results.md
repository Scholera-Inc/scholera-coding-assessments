# Internal Study — Pre-Class Primer Feature

Handed to you as-is. This is the summary an engineer produced after a four-week trial and posted
in the team channel. Nothing has been cleaned up.

---

**What we tested.** Scholera can generate a short "primer" before each class: a few paragraphs
summarising what the upcoming lecture covers, delivered to students the evening before.

We ran it for four weeks in eleven sections. Six sections got primers (treatment), five did not
(control). We measured whether a student submitted the following assignment on time, and asked
those who did to rate the primer's usefulness 1–5.

**Headline result.** On-time submission was **7.4 percentage points higher** in sections that
received primers. Satisfaction averaged 4.1 out of 5.

**Breakdown by student level.**

| Student level | Group | Students | Submissions observed | On-time % | Mean usefulness (n rated) |
|---|---|---:|---:|---:|---|
| Undergraduate, year 1–2 | control | 214 | 1,284 | 71.2% | — |
| Undergraduate, year 1–2 | treatment | 259 | 1,554 | 78.9% | 4.0 (n=171) |
| Undergraduate, year 3–4 | control | 188 | 1,128 | 79.5% | — |
| Undergraduate, year 3–4 | treatment | 201 | 1,206 | 85.1% | 4.2 (n=139) |
| Graduate | control | 9 | 54 | 74.1% | — |
| Graduate | treatment | 4 | 24 | 95.8% | 4.9 (n=4) |

**What jumps out.** The graduate cohort is dramatically more responsive — on-time submission
jumped from 74% to nearly 96%, and they rated the feature 4.9 out of 5, the highest score
anywhere in the study. That is a 21.7 point lift, roughly triple what we saw for undergraduates.

**Proposed next step.** Prioritise primers for graduate sections in the next release and build
the graduate-specific tuning we discussed. There is also an argument for charging more for the
graduate tier given the engagement numbers.

---

**Other things we noticed, unsorted:**

- Sections whose professor posted primers within 24 hours of class saw better numbers than those
  who scheduled them days ahead. We did not control for this and it may just be that engaged
  professors are engaged in other ways too.
- Two treatment sections had a professor who also switched to weekly quizzes during the trial
  period.
- One control section's professor was on leave for two of the four weeks.
- Usefulness ratings were voluntary. Roughly two-thirds of treatment students rated at all.
- We did not track whether students actually opened the primer, only that it was sent.

---

*Your memo should tell the team what this data supports, what it does not, and what you would
do next.*
