# How the beta feedback (message-2.md) was addressed

Reference notes mapping each of the 7 lecturer feedback points to the
specific fix/feature that addresses it, for turning into your own video
walkthrough script. Organised by feedback number for easy cross-referencing
against `message-2.md`.

---

## 1. Diegetic feedback was less useful than non-diegetic

**Issue:** watching the companion jump a gap doesn't tell the player what
they specifically did wrong, while text like "you jumped too late" does.

- Every hazard now classifies exactly what the player did before failing —
  didn't jump, jumped too early, jumped too late, or "something else went
  wrong even though timing was fine" — and the companion demonstrates a
  **different route** for each one, not the same jump regardless of mistake.
- Missed jump: she turns to face the player, barks, and crouches before
  leaping — a clear "there was a jump required here" beat.
- Early jump: she runs past the point where the player actually took off,
  visibly pauses there, then continues to the correct takeoff point before
  jumping — "not here, here."
- This is the same underlying mechanism the HUD text uses (see point 7) —
  same information, expressed as a route and a hesitation beat instead of a
  sentence.

## 2. "The player reacts physically to failure" was unclear

**Issue:** unclear whether "player" meant the participant or the character,
and the physical reaction wasn't obviously different between conditions.

- Refers to the **player character** (her on-screen avatar), not the person
  playing — specific to the diegetic condition.
- On failure she plays a short reaction animation matching the cause: a
  stumble for falling short, a recoil for hitting something like spikes.
- In the non-diegetic condition, the character does **not** perform this
  reaction at all — the same cause is written out as HUD text instead. That
  contrast is the clearest single behavioural difference between the two
  conditions.

## 3. Moving-platform feedback didn't demonstrate the correct action

**Issue:** companion appeared to glide across the screen instead of
interacting with the platform; arrows didn't show what to actually do.

- Companion now tracks the platform's real, live position every frame: hops
  on, holds her footing as it carries her, and jumps off from wherever it
  actually ends up — not a fixed point authored in the editor.
- Same per-mistake differentiation from point 1 now applies to platforms
  too (previously they were the one hazard type that showed the same
  generic boarding animation regardless of mistake).
- Arrow shows exactly the three things asked for: a ring at the platform's
  live position ("stand here"), and an arrow from that ring to the landing
  spot ("jump here, to here") — both update live with the platform.

## 4. Some non-diegetic feedback was too obvious

**Issue:** "You hit the spikes, jump over them" doesn't say anything the
player didn't already know.

- Every message is now specific to the mistake, not the obstacle: "You
  didn't jump — jump over the spikes," "Jumped too early — take off later,"
  "Jumped too late — take off sooner."
- The obstacle name only ever appears as context; the message itself is
  always the corrective action.

## 5. The system may not detect what the player actually did

**Issue:** an example was found where the feedback described a bad jump even
though the player hadn't jumped at all.

- The player character tracks whether she jumped, where from, and when, on
  every attempt.
- When a hazard triggers, that tracked data — not a guess based on which
  hazard it was — decides which of the four mistake categories applies.
- Two different mistakes at the same hazard (e.g. no jump vs. an early
  jump) now produce two different, correctly-labelled responses.

## 6. Feedback focused on the obstacle instead of the player's mistake

**Issue:** knowing you hit spikes or fell in a gap doesn't say what to change
next time.

- Same underlying fix as point 5, from the pipeline side: logic changed from
  "hazard detected → generic message" to "failure detected → check what the
  player actually did → decide which mistake that was → show feedback for
  *that* mistake."
- This single pipeline now runs uniformly for every hazard type — gaps,
  spikes, moving platforms, and the start-edge.

## 7. The two conditions may not be equivalent

**Issue:** if non-diegetic explains the precise reason while diegetic only
demonstrates the action, participants aren't getting the same information.

- Both conditions read from the **exact same underlying data** for every
  failure — the same classified mistake, the same authored corrective
  route. They're two presentations of one shared resource, not two
  independently written systems that happen to look similar.
- Diegetic renders that data as the companion's path plus a physical
  reaction cue; non-diegetic renders the identical route as a screen arrow
  and the same cause as text.
- Moving platforms were the last place this wasn't fully true: the
  non-diegetic text was already mistake-specific, but the diegetic
  companion showed the same generic boarding animation regardless of what
  the player did. That gap is now closed (see point 3) — both conditions
  carry the same information for every hazard type, not just most of them.

---

**Common thread across all 7:** almost every fix happened at the level of
*what the game detects and decides*, not *what it shows you* — once
detection and decision-making are shared and correct between conditions,
both presentations follow from the same source.

---

# Discuss how the system addresses the primary and sub-research questions

> Note: drafted from Deliverable 5's own text (primary question,
> sub-questions, and their listed sources — Literature vs. Empirical) plus
> the actual, verified behaviour of the codebase.

**Primary question:** *The Effect of Diegetic Versus Non-Diegetic Failure
Feedback on Player Frustration and Perceived Competence in a 2D Platformer
Game.*

The system is the instrument through which the manipulation named in the
primary question — diegetic vs. non-diegetic failure feedback — is actually
delivered to participants. It is not itself a source of evidence for the
answer; it is what makes the comparison possible to run at all. Both
conditions are built on one shared failure pipeline
(`FailureController.trigger_failure()`): the same hazard-detection logic,
the same classification of what the player did wrong, the same timing
constants (onset delay, feedback duration, recovery cost), and the same
underlying `FailureData` resource per hazard. The single point where the two
conditions diverge is one branch (`_active_presenter()`) that decides which
of two presenter objects receives the already-decided feedback: a
diegetic presenter that has the companion demonstrate the correct route and
the player character play a physical reaction, or a non-diegetic presenter
that shows HUD text and a screen-space arrow instead. Holding everything
else constant while varying only this one channel is what allows any
measured difference in frustration or perceived competence to be
attributed to the feedback modality itself, rather than to some
confound (different task difficulty, different timing, different amount of
information) that would otherwise undermine the primary question's
answer.

### Sub-question 1 (Literature): "How do existing definitions distinguish diegetic from non-diegetic game interfaces and feedback?"

The system does not answer this question — it is answered by the
literature review, not by data the system produces. The relationship runs
the other way: the system's two conditions are a concrete *operationalisation*
of a definition drawn from that literature (an in-world companion and
character reaction the player character could plausibly perceive, versus
HUD text and an arrow that exist only on the interface layer). The system
can be used to illustrate or ground that literature-based distinction with
a working example, but it plays no role in establishing the answer itself.

### Sub-question 2 (Literature): "How does interface diegesis compare to non-diegesis in terms of its effect on immersion, frustration, and perceived competence, according to existing research?"

Same as sub-question 1: this asks what *existing research* has already
found, so it is answered entirely through the literature review. The system
has no role in answering it — it doesn't survey prior studies, it produces
new data from this one. If anything, this question's answer (from
literature) is what the system's design was informed by, not something the
system contributes evidence toward.

### Sub-question 3 (Empirical): "How does diegetic failure feedback compare to non-diegetic failure feedback in terms of players' self-reported frustration and perceived competence?"

This is where the system is central. It is the mechanism that produces the
two conditions participants actually experience, which they then rate via
questionnaire — the system does not measure frustration or competence
itself, but without it there is no manipulation for the self-report
instrument to be measuring a reaction to. Two design facts matter for this
question's validity specifically: first, both conditions run through the
identical `FailureController` pipeline and shared `Config` timing constants
(onset delay, feedback duration, demo duration, respawn settle), so
recovery cost and pacing are identical regardless of condition; second,
every hazard's `FailureData` resource is shared verbatim between the two
presenters, so the *content* of the correction (which mistake was made, and
what the correct action was) is the same in both conditions — only its
presentation channel changes. Together these mean a difference in
self-reported frustration or competence between conditions can be
attributed to the feedback channel, which is the comparison this
sub-question asks for.

### Sub-question 4 (Empirical): "How do players' descriptions of failure, competence, and motivation to continue compare between the diegetic and non-diegetic conditions?"

The system plays the same instrumental role as sub-question 3 — it is what
generates the experience participants are then asked to describe in
interview, rather than something that captures qualitative data itself.
One further design detail is relevant here: the companion is present in
both conditions from the start of the game, not only appearing at the
moment of failure — a deliberate choice so that its presence itself isn't
part of what differs between conditions, only its behaviour at the moment
of failure is (demonstrating vs. staying neutral). This matters for this
sub-question because it means participants' descriptions of the failure
experience can be attributed to how the correction was communicated, not to
an incidental difference in whether a companion character was on screen at
all.

### Summary: role toward the primary question

The system's contribution to the primary question is entirely as the
controlled delivery mechanism for its independent variable. It does not
answer the two literature-sourced sub-questions (1 and 2) — those come from
the literature review — but it is the sole means by which the two
empirical sub-questions (3 and 4) can be answered at all, since both depend
on participants experiencing a genuinely equivalent pair of conditions that
differ only in feedback channel. The literature sub-questions establish
*what* the diegetic/non-diegetic distinction means and *what prior research
predicts*; the system then tests that distinction empirically, in a
purpose-built 2D platformer, producing the self-report and interview data
that sub-questions 3 and 4 are drawn from — which is, in turn, the direct
evidence for the primary question itself.

---

# How the data-gathering session will be carried out

Drafted from Deliverable 4's methodology, sampling, and instrument sections
(Appendices A and B), updated where your lecturer's comments on that
deliverable call for a change. Flagged inline wherever this differs from
what Deliverable 4 originally said.

### How many people will you use?

Between 10 and 15 participants, recruited through convenience sampling.

**Changed from Deliverable 4:** the original text restricted this to
university students; your lecturer questioned why ("they can be friends
and family too"), so the pool should be described as convenience sampling
more broadly — university students, friends, and family — rather than
students specifically. Nothing else about the number changes.

### How long will the data-gathering session last?

Approximately 25–30 minutes per participant, broken down as:

- Up to 15 minutes of gameplay (assigned condition only — each participant
  plays one version, not both).
- A short post-play questionnaire (a few minutes).
- A semi-structured interview, roughly 5 minutes, audio-recorded.

### Will you divide the participants into groups? If so, how?

Yes — a between-subjects design with two groups, diegetic and
non-diegetic, each participant experiencing only one condition. Group
sizes are roughly even (about 5–8 per condition at n=10–15).

Assignment is by randomisation **stratified by self-reported gaming
skill**, collected in the pre-session demographic questionnaire (a 1–7
self-rating), so that more- and less-experienced players end up spread
across both groups rather than clustering in one. This stratification
exists purely to balance the two groups procedurally — it is **not** itself
a research question being tested. (An earlier draft of the research
questions asked whether the diegetic/non-diegetic effect differs by skill
level; your lecturer flagged this as unrelated to the primary question and
not analysable at this sample size, so it was dropped as a question — skill
is still collected and used only to keep the two groups balanced.)

### How will the session work?

1. **Arrival and consent** — participant reads the Participant Information
   Sheet and signs the Informed Consent Form (Appendix A.1/A.2).
2. **Pre-survey** — the demographic questionnaire (Appendix B.1): age,
   gender, gaming frequency, and self-rated gaming skill (1–7). The skill
   rating is used immediately to assign the participant to a condition via
   stratified randomisation.
3. **Gameplay** — the participant plays the build matching their assigned
   condition (diegetic or non-diegetic) for up to ~15 minutes, working
   through the game's hazards and receiving that condition's failure
   feedback throughout.
4. **Post-survey** — immediately after play, the combined post-play
   questionnaire (Appendix B.2): BANGS competence items and GEQ
   tension/annoyance items, presented as one mixed-order questionnaire.
5. **Interview** — a ~5 minute semi-structured, audio-recorded interview
   (Appendix B.3): one opening question, six core questions mapped to
   frustration/competence/motivation-to-continue, and one closing question.
6. **Debrief** — the participant is told the true purpose of the study, that
   the difficulty was intentional, and reminded of their right to withdraw
   their data afterward (Appendix A.5).

### What data types will be collected, and which surveys will you use?

- **Demographic data** (pre-survey, Appendix B.1): age, gender, gaming
  frequency, self-rated skill (1–7). Used for sample description and for
  stratified group assignment, not as outcome measures.
- **Quantitative self-report data** (post-survey, Appendix B.2), from two
  validated instruments combined into one questionnaire:
  - **BANGS** (Basic Needs in Games Scale; Ballou et al., 2024) —
    competence satisfaction (3 items) and competence frustration (3 items),
    7-point Likert scale.
  - **GEQ** (Game Experience Questionnaire; IJsselsteijn et al., 2013) —
    tension/annoyance items (3 items: annoyed, irritable, frustrated),
    5-point (0–4) scale.
- **Qualitative interview data** (Appendix B.3): transcribed verbatim,
  anonymised, and analysed using Braun and Clarke's (2006) six-phase
  reflexive thematic analysis.

**Changed from Deliverable 4:** the original analysis plan described the
quantitative data as purely descriptive (means, standard deviations,
effect sizes) with no significance testing, given the small sample. Your
lecturer's comments — repeated at each point this came up — were explicit
that t-tests should still be run comparing the two conditions on the
BANGS/GEQ scores, with the results framed as **exploratory** rather than
purely descriptive, rather than skipping inferential testing altogether.
The interview data continues to carry the main interpretive weight, but the
questionnaire data should now be analysed with t-tests alongside the
descriptive summary, not instead of it.

# Explain how the data gathering will be carried out

The data-gathering procedure is based on the methodology and instruments established in Deliverable 4, with several decisions updated following lecturer feedback.

## How many people will you use?

The study will use approximately **10–15 participants**, recruited through **convenience sampling**.

Recruitment will not be restricted to university students. Participants may include students, friends, family members, or other available volunteers who are willing to participate.

The original Deliverable 4 restricted recruitment primarily to university students, but this was revised after feedback questioning why participation needed to be limited to that group.

---

## How long will the data-gathering session last?

Each participant's session is expected to last approximately **25–30 minutes**.

This will include:

* A short introduction, participant information and informed consent.
* A brief pre-session assessment of gaming experience where required for group balancing.
* Up to approximately **15 minutes of gameplay**.
* A short post-play questionnaire.
* An approximately **5-minute semi-structured interview**.
* A short debrief at the end of the session.

Each participant will experience only one version of the game.

---

## Will the participants be divided into groups?

Yes.

The study follows a **between-subjects experimental design** with two conditions:

* **Diegetic feedback condition**
* **Non-diegetic feedback condition**

Participants will be divided as evenly as possible between the two conditions. With a final sample of 10–15 participants, this should result in approximately **5–8 participants per condition**.

Each participant will experience only one condition. This avoids learning and carry-over effects that could occur if a participant completed the level once and then played the second version already knowing the obstacles and their solutions.

Participants will be assigned between the conditions as evenly and randomly as possible. **Gaming experience may be used as a balancing consideration** to avoid placing most highly experienced or inexperienced players in the same group.

Gaming experience is not treated as a separate research variable or research question. It is used only to help ensure that the two groups are reasonably comparable before gameplay begins.

---

## How will the data-gathering session work?

### 1. Participant information and informed consent

When the participant arrives, the researcher will explain the study procedure and provide the **Participant Information Sheet** and **Informed Consent Form**.

Participants will be informed that:

* Participation is voluntary.
* They may stop participating at any point.
* Their responses will be anonymised.
* Their gameplay experience, questionnaire responses and interview responses will be used for the purposes of the study.

Consent for audio recording of the interview will also be obtained before the session continues.

---

### 2. Pre-session information

Before gameplay begins, only the information necessary for conducting the study will be collected.

A brief indication of the participant's **gaming experience or self-reported gaming skill** may be recorded so that gaming experience is not heavily concentrated in one experimental condition.

This information is used for **procedural group balancing only** and is not treated as an outcome variable.

Unnecessary demographic information that does not contribute directly to answering the research questions does not need to be collected.

---

### 3. Gameplay

The participant will then play the version of the 2D platformer corresponding to their assigned condition for up to approximately **15 minutes**.

Both groups experience the same:

* Level.
* Hazards.
* Gameplay mechanics.
* Difficulty.
* Failure-detection logic.
* Feedback timing.
* Recovery cost.
* Underlying corrective information.

The only intended experimental difference is **how the failure feedback is presented**.

In the **diegetic condition**, corrective information is communicated through in-world elements such as the companion's demonstration and the player character's physical response.

In the **non-diegetic condition**, the same underlying corrective information is communicated through interface elements such as HUD text and visual arrows.

The game is designed to be sufficiently challenging that participants are likely to fail several times and therefore experience the feedback system.

However, **failures are not artificially triggered or faked**. Participants fail naturally through normal interaction with the game.

This is important because the study is investigating participants' responses to genuine gameplay failure rather than to scripted or unfair failures.

---

### 4. Post-play questionnaire

Immediately after gameplay, participants will complete the post-play questionnaire.

The questionnaire collects **quantitative self-report data** relating to the two main dependent variables:

* **Perceived competence**
* **Frustration**

Two established instruments are used.

#### BANGS — Basic Needs in Games Scale

The relevant BANGS competence items will measure:

* **Competence satisfaction**
* **Competence frustration**

Three items are used for each dimension, using a **7-point Likert scale**.

These responses provide the quantitative measure of participants' perceived competence after experiencing their assigned feedback condition.

#### GEQ — Game Experience Questionnaire

Relevant items from the GEQ **tension/annoyance** component will be used to measure frustration.

The selected items examine whether participants felt:

* Annoyed.
* Irritable.
* Frustrated.

These items use the GEQ's **0–4 response scale**.

The BANGS and GEQ items will be presented together as a single post-play questionnaire.

---

### 5. Semi-structured interview

After completing the questionnaire, each participant will take part in an approximately **5-minute semi-st**
