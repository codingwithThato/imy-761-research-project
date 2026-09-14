# Video walkthrough script — addressing lecturer feedback (message-2.md)

Draft narration script for the demo video, addressing each point from the
beta-demonstration feedback in order. Written to be read/recorded as
voiceover over matching gameplay footage — screen directions are in
`[brackets]`; everything else is spoken narration. Tweak freely for your own
voice before recording; the structure and the feature references underneath
are the part worth keeping intact, since they're what ties the video back to
the specific feedback.

---

## Intro

[Show: title screen / launcher]

"Hi, I'm Thato. After the beta demonstration, I got seven pieces of feedback
on the failure-feedback system in the two experimental conditions. I want to
walk through each one and show exactly what changed in response — not just
tell you it's fixed, but show you the mechanism behind the fix."

---

## 1. Diegetic feedback was less useful than non-diegetic

[Show: a gap hazard, failed with a late jump, diegetic condition]

"The concern was that watching the companion jump over a gap doesn't tell
the player what they specifically did wrong — while text like 'you jumped
too late' does. The fix wasn't to simplify the message, it was to make the
companion's *route* carry the same specific information the text does.

Every hazard in the game now classifies exactly what the player did before
failing — didn't jump, jumped too early, jumped too late, or something else
— and the companion demonstrates a *different, mistake-specific route* for
each one. [Show: same hazard, NO_JUMP failure — companion turns, barks,
crouches, then jumps] For a missed jump, she turns to face you, barks, and
crouches before leaping — a clear 'there was a jump required here' beat, not
just a jump. [Show: JUMPED_TOO_EARLY failure] For an early jump, she runs
past the point where you actually took off, visibly pauses there, then
continues on to the correct takeoff point before jumping — 'not here, here.'
This is the same mechanism the text uses; it's just expressed as a route and
a hesitation beat instead of a sentence."

---

## 2. "The player reacts physically to failure" was unclear

[Show: player character failing in diegetic condition — a stumble or recoil
animation playing on her]

"This referred to the *player character* — her on-screen avatar, not the
person playing — and it's specific to the diegetic condition. When she
fails, she plays a short reaction animation that matches the cause: a
stumble if she simply fell short, or a recoil if she hit something like
spikes. [Show: same failure in non-diegetic condition — no reaction
animation, just HUD text] In the non-diegetic condition, the character
doesn't perform this reaction at all — the same cause is instead written out
as HUD text. That contrast is deliberate and is now the clearest single
difference between the two conditions."

---

## 3. Moving-platform feedback didn't demonstrate the correct action

[Show: a moving-platform hazard, diegetic, full sequence]

"The companion needed to actually land on the platform, ride it, and jump
off at the right moment — not glide across the screen. She now tracks the
platform's real, live position every frame: she hops on, holds her footing
as it carries her, and jumps off from wherever it actually ends up, not a
fixed point drawn in the editor. [Show: NO_JUMP variant on a platform —
bark/crouch before boarding] The same per-mistake differentiation from point
one applies here too — missed jump, early jump, and late jump each get a
distinct demonstration before she boards.

[Show: non-diegetic arrow on the same platform hazard] For the arrow, we
went with exactly the three things asked for: where to stand — a ring drawn
at the platform's live position — when to jump, and where to move, shown as
an arrow from that ring to the landing spot. Both update live with the
platform instead of pointing at empty air."

---

## 4. Some non-diegetic feedback was too obvious

[Show: a spikes hazard failure with the HUD text visible]

"'You hit the spikes, jump over them' doesn't tell you anything you didn't
already know. Every message in the game is now specific to the mistake, not
the obstacle: 'You didn't jump — jump over the spikes,' 'Jumped too early —
take off later,' 'Jumped too late — take off sooner.' [Show: two or three
different hazards, each with a different mistake-specific message] The
obstacle name only ever appears as context; the message itself is always
about the corrective action."

---

## 5. The system may not detect what the player actually did

[Show: code or diagram — Player tracking jump state]

"This was the most important one to get right, because every other fix
depends on it. The player character tracks whether she jumped, where she
jumped from, and when, on every attempt. When a hazard is triggered, that
information — not a guess based on which hazard it was — decides which of
the four mistake categories applies: no jump, early, late, or a fourth
'something else went wrong even though the timing was fine' case.

[Show: same gap hazard failed two different ways — once with no jump, once
with a clearly early jump — showing the two different resulting messages
and companion routes] Two different mistakes at the same hazard now produce
two different, correctly-labelled responses."

---

## 6. Feedback focused on the obstacle, not the mistake

[Show: a simple flow diagram if available, or just narrate over gameplay]

"This is really the same fix as point five, described from the pipeline
side rather than the detection side. The logic used to be, effectively,
'hazard detected → show a message about this hazard.' It's now 'failure
detected → check what the player actually did → decide which of the four
mistakes that was → show the feedback for *that* mistake' — the same
pipeline runs for every hazard type in the game: gaps, spikes, moving
platforms, and the start-edge, uniformly."

---

## 7. The two conditions may not be equivalent

[Show: side-by-side or back-to-back footage — same hazard, same mistake,
diegetic then non-diegetic]

"This was the one I took most seriously, because if it's true, the whole
comparison the study is built on doesn't hold. The fix is structural, not
cosmetic: both conditions read from the exact same underlying data for every
single failure — the same classified mistake, the same authored corrective
route. The diegetic condition renders that route as the companion's path and
a physical reaction cue; the non-diegetic condition renders the identical
route as a screen arrow and renders the same underlying cause as text. They
are two presentations of one shared piece of data, not two independently
written systems that happen to look similar.

The moving-platform hazards were actually the last place this wasn't fully
true — until recently, the non-diegetic text was already mistake-specific,
but the diegetic companion showed the same generic boarding animation
regardless of what the player did. [Show: platform hazard, NO_JUMP, diegetic
— bark and crouch before boarding] That gap is closed: the companion now
gets the same bark-and-crouch or early-jump pause on platforms that gaps and
spikes already had, so both conditions carry the same information for every
hazard type in the game, not just most of them."

---

## Closing

[Show: level-select or full playthrough montage]

"That's all seven points. The common thread is that almost every fix
happened at the level of *what the game detects and decides*, not at the
level of *what it shows you* — because the moment detection and decision-
making are shared and correct, both presentations follow from the same
source almost for free."
