extends Node
## AUTOLOAD as "Config".
##
## Single source of truth for (a) which condition is active and (b) every
## timing constant used by the failure sequence.
##
## EQUIVALENCE NOTE: the constants below are read by BOTH presenters and by
## FailureController. They are deliberately NOT per-condition. This is what
## makes "the conditions differ only in delivery channel" a structural fact
## rather than a promise.

enum Condition { DIEGETIC, NON_DIEGETIC }

# --- Session state (set on the launcher screen, before play) ---
var condition: Condition = Condition.DIEGETIC

# --- Equivalence constants: IDENTICAL IN BOTH CONDITIONS ---
## Delay between the death and the feedback appearing.
const FEEDBACK_ONSET := 0.18
## How long the feedback stays on screen / in world.
const FEEDBACK_DURATION := 2.0
## How long the demonstration itself takes to play out.
## Must be <= FEEDBACK_DURATION.
const DEMO_DURATION := 1.2
## Pause after respawn before the player regains control.
const RESPAWN_SETTLE := 0.3
## How long the stumble reaction plays before a player who fell out of view
## (pit/gap/edge) is hidden. Identical in both conditions.
const FALL_REACT_TIME := 0.25

## Total time the player is without input on any failure.
## Same in both conditions, by construction.
static func total_lock_time() -> float:
	return FEEDBACK_ONSET + FEEDBACK_DURATION + RESPAWN_SETTLE


func condition_name() -> String:
	return "diegetic" if condition == Condition.DIEGETIC else "non-diegetic"


## Prints the timing table. Run this once and paste the output into your
## Materials section as evidence of cross-condition equivalence.
func dump_timings() -> void:
	print("--- Failure feedback timing (identical in both conditions) ---")
	print("condition under test : %s" % condition_name())
	print("feedback onset       : %.3f s" % FEEDBACK_ONSET)
	print("feedback duration    : %.3f s" % FEEDBACK_DURATION)
	print("demo duration        : %.3f s" % DEMO_DURATION)
	print("respawn settle       : %.3f s" % RESPAWN_SETTLE)
	print("fall reaction (pit/gap/edge only): %.3f s" % FALL_REACT_TIME)
	print("total input lock     : %.3f s" % total_lock_time())
	print("---------------------------------------------------------------")
