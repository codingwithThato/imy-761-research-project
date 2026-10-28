# Session handoff — Deliverable 7 write-up

Written 2026-10-28, end of a session with Thato on branch `Thato`.
Written so that **Chenoa** (or Claude in a new session) can pick up with no
other context. To use it with Claude: "read SESSION-HANDOFF.md and continue
from there".

**Replaces the 2026-10-27 handoff.** Everything still relevant is carried
forward below.

---

## 1. Project in one paragraph

We built a 2D platformer in Godot (`research-game/`, 5 levels) to study
**the effect of diegetic vs non-diegetic failure feedback on player
frustration and perceived competence**. Every failure goes through one
shared pipeline (`scripts/FailureController.gd`). It checks what the player
actually did (didn't jump, jumped too early, jumped too late, or other) and
picks the matching corrective feedback. Only the *presenter* differs between
the two versions:

- **Diegetic** (`DiegeticPresenter.gd`): the dog companion demonstrates the
  correct route for that mistake, and the player character stumbles or
  recoils.
- **Non-diegetic** (`NonDiegeticPresenter.gd`): HUD text ("Jumped too early —
  take off later") plus an on-screen arrow (`ArrowOverlay.gd`).

The dog is on screen in both versions; it only demonstrates in the diegetic
one. Content, timing and difficulty are identical across conditions. This
was the fix for the lecturer's beta feedback (see `message-2.md` and
`WALKTHROUGH-NOTES.md`).

## 2. Where we are

- Game dev: **finished**. Data collection: **finished**.
- Now writing **Deliverable 7**, one exercise at a time. Thato pastes the
  exercise wording, Claude drafts, Thato corrects anything that happened
  differently.
- Ethics clearance: Thato said to ignore it. Don't raise it as a blocker.

## 3. What actually happened in data collection (overrides D4 and the D6 script)

D4 and the D6 video script describe the *plan* (10–15 people, stratified
randomisation by gaming skill, demographics questionnaire, consent forms).
Most of that did not happen. Write D7 from these facts:

- **Allocation:** participants were allocated to conditions as they became
  available. Not randomised and not stratified. Agreed wording: "Participants
  were allocated to conditions as they became available." Limitations line:
  "Allocation was not formally randomised, which may have introduced
  selection bias; future work should use a randomisation procedure such as a
  shuffled allocation list."
- **Sessions:** 7 in person on Thato's MacBook. 3 online over a video call
  with screen sharing; the game was sent via Google Drive (2 macOS, 1
  Windows; a Windows build was made for this).
- **Questionnaire:** Google Forms only. 9 items: BANGS competence items 1–6
  on a 1–7 scale, GEQ tension/annoyance items 7–9 on a 0–4 scale. Scoring
  key: `materials/post-play-questionnaire-scoring-key.md`.
- **Interview:** 8 open-ended questions, the ones in **D4 Appendix B.3**
  (1 opening, 6 core, 1 closing). Audio-recorded, transcribed automatically,
  anonymised. Note: `materials/playtest-session-script.md` still lists an
  older 5-question version. D4's list is the correct one.
- **Observation notes:** Thato typed notes of things players said or pointed
  out while playing. They exist for 7 of the 10 sessions; three diegetic
  sessions and one non-diegetic session have none. In D7, describe them as
  informal and partial. **The raw notes contain real first names. Never put
  them in the repo or in any linked file without replacing names with
  P-codes.**
- **Not collected:** death counts, age, gender or any other demographics.
- **Analysis plan:** per participant, three subscale means: competence
  satisfaction = items 1, 3, 5; competence frustration = items 2, 4, 6;
  tension/annoyance = items 7–9. Compare the groups with Welch's
  independent-samples t-tests and report M, SD, t, p and Cohen's d. Frame as
  **exploratory** (the lecturer asked for t-tests even with a small sample).
  Interviews: Braun and Clarke's (2006) six-phase reflexive thematic
  analysis (already named in D4 Exercises 2 and 4 and in its references).

### Open decision: sample size and repeat players

- Two people played **both** versions: non-diegetic first, then diegetic as
  a second session. The session list counts them twice to reach 10.
- Claude will not write this up as if they were four different people. The
  two honest options it offered:
  - **A (recommended):** drop their second sessions. Final n = 8, 4 per
    condition. Wording: "Two participants played both versions of the game;
    only their first session was included in the analysis, giving a final
    sample of eight (four per condition)."
  - **B:** keep all 10 and disclose. Wording: "Two participants completed
    both conditions, with their second session in the diegetic condition.
    Because prior exposure to the levels may have influenced these sessions,
    this is noted as a limitation."
- Not decided yet. It affects every D7 section that states n, the t-tests,
  and Limitations.
- One participant was still marked "pending" in the notes. Confirm whether
  they played, and in which condition, before stating group sizes.

## 4. Research questions (verified word for word against the D5 PDF)

- **Primary:** *The Effect of Diegetic Versus Non-Diegetic Failure Feedback
  on Player Frustration and Perceived Competence in a 2D Platformer Game.*
- **SQ1 (Literature):** How do existing definitions distinguish diegetic
  from non-diegetic game interfaces and feedback?
- **SQ2 (Literature):** How does interface diegesis compare to non-diegesis
  in terms of its effect on immersion, frustration, and perceived
  competence, according to existing research?
- **SQ3 (Empirical):** How does diegetic failure feedback compare to
  non-diegetic failure feedback in terms of players' self-reported
  frustration and perceived competence?
- **SQ4 (Empirical):** How do players' descriptions of failure, competence,
  and motivation to continue compare between the diegetic and non-diegetic
  conditions?

## 5. Deliverable 7 progress

### Exercise 1 (revisit research questions): DONE

"How it will be answered" column, as agreed:

- **SQ1:** Literature: a review of how games research defines diegetic and
  non-diegetic interfaces, and the frameworks used to tell them apart.
- **SQ2:** Literature: a review of previous empirical studies comparing
  diegetic and non-diegetic interfaces and feedback, focusing on their
  reported effects on immersion, frustration, and perceived competence.
- **SQ3:** Empirical (quantitative): post-play questionnaire using BANGS
  competence satisfaction and frustration items and GEQ tension/annoyance
  items. Subscale scores are compared between conditions with exploratory
  independent-samples (Welch's) t-tests.
- **SQ4:** Empirical (qualitative): semi-structured post-play interviews,
  analysed with Braun and Clarke's reflexive thematic analysis and supported
  by observation notes of comments players made while playing.

Keep the question cells word for word as in D5. The "how" text goes only in
the second column.

### Exercise 2 (data collection details, 150–250 words): DONE

Final text was given in chat in the 2026-10-27 session ("five" was changed
to "eight" open-ended questions). **May need one added sentence** about the
observation notes, since those were confirmed after it was written.

### Exercise 3 (the data and its significance): DRAFTED

Format: for each empirical SQ, give the question, a link to the relevant
raw data, and a short discussion of why that data answers it. Draft text:

> **Research sub-question 3:** How does diegetic failure feedback compare to
> non-diegetic failure feedback in terms of players' self-reported
> frustration and perceived competence?
>
> **Data:** post-play questionnaire responses from both the diegetic and
> non-diegetic groups. Each participant rated six BANGS items on a 1–7 scale
> (competence satisfaction and competence frustration) and three GEQ
> tension/annoyance items on a 0–4 scale. [link to Google Sheet]
>
> The data allow us to answer this sub-question by comparing the scores of
> the two groups on three subscales: competence satisfaction, competence
> frustration, and tension/annoyance. Each subscale score is the mean of its
> three items for each participant. Comparing the group means, together with
> exploratory independent-samples t-tests and effect sizes, shows whether
> diegetic feedback was associated with higher, lower, or similar levels of
> frustration and perceived competence compared to non-diegetic feedback.
> Competence satisfaction and competence frustration are kept separate, as
> BANGS treats them as distinct constructs. This means we can see whether
> feedback modality affected how capable players felt, how incapable they
> felt, or both.
>
> **Research sub-question 4:** How do players' descriptions of failure,
> competence, and motivation to continue compare between the diegetic and
> non-diegetic conditions?
>
> **Data:** anonymised transcripts of the semi-structured post-play
> interviews with participants from both groups, together with typed
> observation notes of comments participants made while playing. [link to
> Google Doc(s)]
>
> The interview data allow us to identify how participants experienced and
> made sense of failure in their version of the game. This includes whether
> they understood what they had done wrong, how capable they felt of
> improving, and what made them want to keep playing or stop. By analysing
> the transcripts for recurring themes using Braun and Clarke's (2006)
> reflexive thematic analysis, and comparing those themes across the two
> groups, we can see how the way feedback was delivered shaped players'
> accounts of frustration and competence. The observation notes capture
> players' reactions in the moment, such as remarks about the companion's
> usefulness or the fairness of hazards. These support and add context to
> the themes from the interviews.

Agreed: no participant quotes in this exercise. Quotes go in the
analysis/results exercise.

**To do before submitting Exercise 3:** make the linked files.

- **Sheet (SQ3):** copy the Google Form responses sheet (don't link the
  live one), delete timestamp/name/email columns, add `Participant`
  (P1, P2, …) and `Condition` (Diegetic / Non-diegetic) columns, optionally
  add the three subscale-mean columns, and share as "Anyone with the link →
  Viewer".
- **Doc (SQ4):** one Google Doc with each transcript under its P-code and
  condition, names spoken in the recordings replaced, and the anonymised
  observation notes in a section at the end (without the name list).
- Then Claude can compute subscale means and run the Welch's t-tests from
  the anonymised sheet. Those numbers are needed in a later exercise.

### Next: Exercise 4 onwards

Thato hasn't pasted the wording yet.

## 6. Observation notes, summarised (no names)

Useful later as supporting evidence for SQ4 themes and for the discussion:

- **Everyone:** struggled at the small gap after the spikes, and thought they
  had to run and jump to clear it. This is a level-design or clarity issue,
  not tied to either condition.
- **Spike hitbox felt too big:** two diegetic players.
- **Frustration, mostly in non-diegetic:** one player "hates the spikes…
  got really frustrated"; one said the dog "should die with player, it's
  unfair"; one said the "dog is useless". Interpretation: in the
  non-diegetic version the dog is present but never helps, so players saw
  it as useless or unfairly safe. Worth bringing up in the discussion.
- **Wanted a sense of completion:** one diegetic player asked for a
  congratulations message at the end of levels; one non-diegetic player
  noted there were no completion flags. Both relate to competence.
- **Other requests:** a double jump, and a visual bug where water comes out
  of the wall.

## 7. Still open

- The sample-size and repeat-player decision (section 3).
- D4/D5 analysis text says "No significance testing is performed". D7 and
  the final article must use the t-tests instead.
- Describe the recruitment that actually happened (friends and family were
  allowed, per the lecturer's D4 comment).
- `main` is far behind `dev`/`Thato`/`Chenoa`. Merge before submission if
  the submission is from `main`.

## 8. Reference

- D4 PDF (methods, instruments, interview questions in Appendix B.3):
  `Thato+Chenoa_Deliverable_4.pdf`
- D5 PDF (research questions): `Thato+Chenoa Deliverable 5-3.pdf`
- Lecturer comments: `d4 comments.md` (D4), `message-2.md` (beta)
- D6 video script: `d6 script`. Walkthrough notes: `WALKTHROUGH-NOTES.md`
- Google Form (participant): https://docs.google.com/forms/d/e/1FAIpQLSejzDxG0TOUj1Oq0AraPudzvKn4xFYPFzB97uOl1XckzEqd8Q/viewform
- Edit form: https://docs.google.com/forms/d/1PZ_tcMwCMwcHJJhIzB3SR_2CPGO9Mn2Pb5JTbVLlkrs/edit
- Responses sheet (contains raw data, don't share directly): https://docs.google.com/spreadsheets/d/1lYIDGeJyiASjrV2ld1CvjLk75bJMLVaEk7ygG-PLdpc/edit
- Builds live in `research-game/T&Cs_GAME/` (gitignored, too big for
  GitHub). Share them via the D6 Google Drive folder.
- Materials: `materials/` (questionnaire PDF/MD, scoring key, playtest
  session script, Google Form Apps Script).
