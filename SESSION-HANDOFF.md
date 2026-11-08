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
  P-codes.**a
- **Not collected:** death counts, age, gender or any other demographics.
- **Analysis plan:** per participant, three subscale means: competence
  satisfaction = items 1, 3, 5; competence frustration = items 2, 4, 6;
  tension/annoyance = items 7–9. Compare the groups with Welch's
  independent-samples t-tests and report M, SD, t, p and Cohen's d. Frame as
  **exploratory** (the lecturer asked for t-tests even with a small sample).
  Interviews: Braun and Clarke's (2006) six-phase reflexive thematic
  analysis (already named in D4 Exercises 2 and 4 and in its references).

### Sample (confirmed by Thato 2026-10-29)

- **10 different participants, 5 per condition. There were no repeat
  players.** 
- Diegetic: P1, P2, P5, P7, P9. Non-diegetic: P3, P4, P6, P8, P10 (numbers
  as in the anonymised responses sheet).

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

---

## 9. Update 2026-10-29: Exercise 4 (data analysis), SQ3 done

Written at the end of a session with Thato. Facts here override anything
above that disagrees.

### Corrections confirmed by Thato

- **No repeat players.** 10 different participants, 5 per condition. The
  lecturer knows this. Section 3 was corrected in this session.
- **Conditions** (participant numbers as in the responses sheet):
  diegetic = P1, P2, P5, P7, P9; non-diegetic = P3, P4, P6, P8, P10.
- Never write participants' real names anywhere. Use P-codes only.

### Data source

- Anonymised responses sheet (shared as "anyone with the link", no names
  or emails): https://docs.google.com/spreadsheets/d/1qMdhUKISLLb_6N0CBHgzejskS1582fxUGWZZg9DCmcU/edit?usp=sharing
  Claude downloads it with `.../export?format=csv`. It has no Condition
  column, so use the mapping above.
- The D7 Google Doc: https://docs.google.com/document/d/1Glseuip_SZ43iJ6DIVuiu3RjshjBADPv25jVKjvipX8/edit?usp=sharing
  Claude can't edit it (no Google sign-in; Claude in Chrome wasn't
  connected), so Thato pastes content in by hand.

### Exercise 4 wording (summary)

For each empirically answered sub-question (SQ3 and SQ4 only), give the
question, describe the analysis performed, and give the analysis results
and a clear, concrete answer. SQ1/SQ2 (literature) and the primary
question are not answered here. The brief's interview example says
thematic analysis should give a list of themes, links between them, and
a diagram (thematic map).

### SQ3: final text (agreed)

**How does diegetic failure feedback compare to non-diegetic failure
feedback in terms of players' self-reported frustration and perceived
competence?**

**Analysis performed**

The post-play questionnaire responses were scored following the guidance
for each instrument. For each participant, three subscale scores were
calculated as the mean of their items:
- competence satisfaction (BANGS items 1, 3 and 5; scale 1–7)
- competence frustration (BANGS items 2, 4 and 6; scale 1–7)
- tension/annoyance (GEQ items 7, 8 and 9; scale 0–4)

As recommended by Ballou et al. (2024), competence satisfaction and
competence frustration were kept as separate constructs. They were not
reverse-coded and combined into one score. Each subscale was compared
between the diegetic group (n = 5) and the non-diegetic group (n = 5)
using a two-tailed Welch's independent-samples t-test (α = .05). Welch's
test does not assume equal variances, which suits small groups. Cohen's d
is reported as the effect size. Because the sample is small, these tests
are exploratory.

**Results**

| Subscale | Diegetic M (SD) | Non-diegetic M (SD) | t(df) | p | d |
|---|---|---|---|---|---|
| Competence satisfaction (1–7) | 6.07 (1.01) | 6.00 (1.35) | t(7.40) = 0.09 | .932 | 0.06 |
| Competence frustration (1–7) | 2.40 (0.98) | 2.53 (1.22) | t(7.66) = −0.19 | .854 | −0.12 |
| Tension/annoyance (0–4) | 1.33 (0.85) | 1.73 (1.30) | t(6.89) = −0.58 | .583 | −0.36 |

[Figure X: `figures/sq3-subscale-comparison.png`]

*Figure X.* Average scores for the diegetic (n = 5) and non-diegetic
(n = 5) groups. Error bars show ±1 standard deviation. There were no
significant differences between the groups on any measure (all p > .05).

Figure X shows the average score of each group on the three subscales.

There was no significant difference in competence satisfaction between
the diegetic group (M = 6.07, SD = 1.01) and the non-diegetic group
(M = 6.00, SD = 1.35); t(7.40) = 0.09, p = .932, d = 0.06.

There was no significant difference in competence frustration between the
diegetic group (M = 2.40, SD = 0.98) and the non-diegetic group (M = 2.53,
SD = 1.22); t(7.66) = −0.19, p = .854, d = −0.12.

There was no significant difference in tension/annoyance between the
diegetic group (M = 1.33, SD = 0.85) and the non-diegetic group (M = 1.73,
SD = 1.30); t(6.89) = −0.58, p = .583, d = −0.36.

**Answer to SQ3:** In this sample, diegetic and non-diegetic failure
feedback produced similar levels of self-reported perceived competence and
frustration. Both groups reported high competence satisfaction and low
competence frustration. Players who received diegetic feedback reported
slightly lower tension/annoyance than those who received non-diegetic
feedback, a small effect (d = −0.36), but the difference was not
statistically significant. With five participants per group, the study
could only reliably detect very large differences, so these results show
no clear effect of feedback type. They do not show that feedback type has
no effect.

### Per-participant subscale scores (for checking)

| P | Condition | Comp. satisfaction | Comp. frustration | Tension/annoyance |
|---|---|---|---|---|
| P1 | Diegetic | 7.00 | 2.00 | 2.00 |
| P2 | Diegetic | 7.00 | 1.67 | 0.00 |
| P3 | Non-diegetic | 7.00 | 1.67 | 1.00 |
| P4 | Non-diegetic | 3.67 | 4.00 | 3.67 |
| P5 | Diegetic | 5.00 | 2.67 | 1.00 |
| P6 | Non-diegetic | 6.00 | 3.33 | 2.33 |
| P7 | Diegetic | 6.33 | 1.67 | 1.67 |
| P8 | Non-diegetic | 6.67 | 1.00 | 0.33 |
| P9 | Diegetic | 5.00 | 4.00 | 2.00 |
| P10 | Non-diegetic | 6.67 | 2.67 | 1.33 |

p-values were computed by hand (SciPy wasn't installed). Worth one check
in JASP/SPSS or Excel `T.TEST(range1, range2, 2, 3)` before submitting.

### Files made (in `figures/`, not yet committed)

- `sq3-subscale-comparison.png`: simple bar chart, 3 panels (one per
  subscale), blue = diegetic, orange = non-diegetic, error bars = ±1 SD.
  Thato asked for it to stay simple: no stats or M/SD printed on it. Don't
  switch to dot plots or bell curves (Thato found them confusing; n = 5 is
  too small for curves anyway).
- `SQ3 table and graph.docx`: Word document with the table (caption
  above), the chart and the Figure caption, for pasting into the Google
  Doc.
- `sq3-table.html`: the table as a web page, for copy-pasting.

### Decisions and explanations agreed with Thato

- Two-tailed tests, because no directional hypothesis is recorded. Switch
  to one-tailed only if D4 stated a direction.
- The null result is fine, not "pointless". For the discussion: small n
  (low power), ceiling effect on competence (both about 6/7), a shared
  difficulty spike at the gap after the spikes, and SQ4 may show
  differences the questionnaire missed (e.g. the dog seen as "useless"/
  "unfair" in the non-diegetic version). Don't change the analysis to get
  significance.

### Next: SQ4

- The analysis description is drafted (Braun and Clarke's six phases;
  transcripts coded with their condition; observation notes used as
  support only, since they exist for 7 of 10 sessions; thematic map as
  Figure X).
- **Waiting on the anonymised interview transcripts** (names replaced with
  P-codes). Then: code them, propose themes with quotes per condition, a
  thematic map diagram, and a comparative answer to SQ4.

---

### Explained to Thato (for SQ3 in Exercise 4)

- **α = .05**: the significance level, set before testing. p < .05 means
  significant. All three SQ3 p-values are well above it. Keep "α = .05" in
  the text; optionally write "with a significance level of α = .05".
- **Cohen's d**: effect size, the mean difference in SD units. Rough
  thresholds are 0.2 small, 0.5 medium, 0.8 large (Cohen, 1988, *Statistical
  power analysis for the behavioral sciences*, 2nd ed., Lawrence Erlbaum).
  The sign is diegetic minus non-diegetic.
- **t(df)**: the t-statistic (mean difference relative to the noise) and the
  degrees of freedom. The decimal df values come from Welch's correction,
  which is expected.

### Next

Unchanged: SQ4 waits on the real anonymised transcripts.

---

## 11. Update 2026-11-05: D7 marked, final-article specs checked

Written at the end of a session with Thato. Facts here override anything
above that disagrees.

### D7 came back marked

- File: `Marked_Thato+Chenoa_Deliverable_7.pdf`. Six comments from
  AE (Annique) Smith. The rubric page isn't filled in, so there's no mark yet.
- Full analysis and fixes: **`d7 comments.md`** (checklist at the bottom).
- In short:
  1. SQ4 needs an explicit "answer to the RQ" paragraph that pulls the five
     themes together (most serious).
  2. Check normality with Shapiro-Wilk first; use Mann-Whitney U where it
     isn't normal. **This replaces the Welch's t-test decision in sections 3
     and 9.**
  3. Report the SQ3 results as paragraphs, not bullet points.
  4. Expand each theme: summary → quotes → contrasting views → wrap-up.
  5. **Drop the observation notes as a data source.** They were never named
     in D4–D6 (checked). This overrides section 3/5/6 guidance on using them
     as support. Mentioning them in limitations is optional.
  6. Enlarge the text in Figure 2 (thematic map).

### Final article (D8) specs checked: no hidden text

All files in `Specifications and Rubrics/` were inspected (PDF character
colours, sizes and positions; docx hidden formatting, comments, tracked
changes, metadata, alt text). Nothing hidden. Visible cues that matter:

- Template Results section requires: M and SD, Shapiro-Wilk, then t-test or
  Mann-Whitney U, reported in APA format; a thematic map for the
  qualitative results.
- Word limits per section, penalised: over in 1–2 sections costs 1%,
  3 sections 2%, 4+ sections 5%. Delete all highlighted template text.
- RQs go at the end of the Introduction as prose, not a table. Literature
  SQs are answered in the Discussion (weight 18/100, the biggest).
- Figures: no titles, caption below. Tables: caption above, horizontal
  lines only, bold headings, centred numbers. UK English, Harvard
  referencing. At least one game screenshot in Materials.
- Participants: state the sampling method with a reason, plus ethics (be
  open about the non-random allocation).
- Don't overstate evidence; explain what n = 5 per group means rather than
  just "small sample".
- Video (max 3 min, voice-over, standalone) and critical reflection are
  10/100 each. Presentation is separate (/16): 15 min plus 5 min of
  questions, including reflection.

### Next session: start here

1. Run Shapiro-Wilk on each subscale × condition (6 tests) using the
   per-participant scores in section 9. Then Mann-Whitney U (U, p,
   r = Z/√N, medians/IQR) wherever normality fails. Install SciPy into the
   scratchpad if needed.
2. Rewrite the SQ3 method + results as APA prose; update Table 1, Figure 1
   caption and Exercise 1 wording.
3. Then the rest of the `d7 comments.md` checklist.
