# Session handoff — Deliverable 7 write-up

Written 2026-10-27, end of a session with Thato on branch `Thato`.
Paste this file to Claude at the start of the next session ("read
SESSION-HANDOFF.md and continue from there").

**Replaces the 2026-10-13/10-20 handoff.** Everything still relevant is
carried forward below.

## Where we are

- Game dev is finished. **Data collection is finished.**
- Now answering the **Deliverable 7** exercises one at a time. Thato pastes
  each exercise; Claude drafts; Thato corrects anything done differently.
- **Ethics clearance: Thato said to ignore it.** Don't raise it as a blocker.

## What actually happened in data collection (overrides D4's plan)

- 10 participants, 5 per condition (diegetic companion vs non-diegetic
  on-screen arrow).
- **Allocation was NOT randomised or stratified.** Participants were
  allocated as they became available. Agreed wording: "Participants were
  allocated to conditions as they became available, with five assigned to
  each version of the game." Don't claim a coin flip or alternation. Add it
  to Limitations: "Allocation was not formally randomised, which may have
  introduced selection bias; future work should use a randomisation
  procedure such as a shuffled allocation list."
- 7 sessions in person on Thato's MacBook. 3 online over a video call
  with screen sharing: the game was sent via Google Drive (2 macOS, 1
  Windows; a Windows build was made for this).
- Questionnaire: **Google Forms only** (9 items: BANGS competence items
  1–6 on a 1–7 scale; GEQ tension/annoyance items 7–9 on a 0–4 scale).
- Interview: **8 open-ended questions**, audio-recorded, transcribed
  automatically, anonymised. Analysis of the transcripts will be described
  in a later exercise.
- No observation notes or death counts were recorded. No age or other
  demographics were collected.
- Analysis plan: three subscale means per participant (competence
  satisfaction = items 1, 3, 5; competence frustration = 2, 4, 6;
  tension/annoyance = 7–9), compared with Welch's independent-samples
  t-tests. Report M, SD, t, p, Cohen's d; frame as exploratory (n = 10).

## Deliverable 7 progress

- **Exercise 2 (data collection details, 150–250 words): DONE.** The final
  text was given in chat. Thato changed "five" to "eight" open-ended
  questions.
- **Exercise 3: next.** Thato hasn't pasted its wording yet.

## Research questions (from D5, copied via WALKTHROUGH-NOTES.md)

- Primary: *The Effect of Diegetic Versus Non-Diegetic Failure Feedback on
  Player Frustration and Perceived Competence in a 2D Platformer Game.*
  Question form, if needed: "What is the effect of ... ?"
- SQ1 (Literature): How do existing definitions distinguish diegetic from
  non-diegetic game interfaces and feedback?
- SQ2 (Literature): How does interface diegesis compare to non-diegesis in
  terms of its effect on immersion, frustration, and perceived competence,
  according to existing research?
- SQ3 (Empirical): How does diegetic failure feedback compare to
  non-diegetic failure feedback in terms of players' self-reported
  frustration and perceived competence? (Questionnaire + t-tests.)
- SQ4 (Empirical): How do players' descriptions of failure, competence, and
  motivation to continue compare between the diegetic and non-diegetic
  conditions? (Interviews.)
- These are copied word for word from `WALKTHROUGH-NOTES.md`, which was
  drafted from D5. **Not yet checked against the D5 PDF itself**, because
  PDF text extraction failed on this machine (no poppler or pypdf). Check
  the PDF before quoting the questions in D7.

## Still open

- D4/D5 analysis text still says "No significance testing is performed";
  the final report must use the t-tests instead.
- The final report should describe the recruitment that actually happened
  (friends & family were allowed).
- `main` is far behind `dev`/`Thato`/`Chenoa`. Merge before submission if
  the submission is from `main`.

## Reference

- Google Form (participant): https://docs.google.com/forms/d/e/1FAIpQLSejzDxG0TOUj1Oq0AraPudzvKn4xFYPFzB97uOl1XckzEqd8Q/viewform
- Edit form: https://docs.google.com/forms/d/1PZ_tcMwCMwcHJJhIzB3SR_2CPGO9Mn2Pb5JTbVLlkrs/edit
- Responses sheet: https://docs.google.com/spreadsheets/d/1lYIDGeJyiASjrV2ld1CvjLk75bJMLVaEk7ygG-PLdpc/edit
- Builds live in `research-game/T&Cs_GAME/` (gitignored, too big for
  GitHub). Share them via the D6 Google Drive folder.
- Materials: `materials/` (questionnaire PDF/MD, scoring key, playtest
  session script, Google Form Apps Script).
