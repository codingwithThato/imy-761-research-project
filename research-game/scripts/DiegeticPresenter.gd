extends FailurePresenter
## DIEGETIC condition.
##
## Put this on a node in the level and add it to group "diegetic_presenter".
##
## Conveys the SAME information as the non-diegetic presenter, through the
## game world instead of the interface:
##   cause      -> the player character's in-world reaction (stumble/recoil/
##                 overshoot), read from data.cause_cue
##   correction -> the companion walks data.demo_points
##
## No HUD, no text, no screen-space element. Everything the player sees here
## is something the character could plausibly perceive.

## Optional: an in-world sound that plays with the demonstration.
@export var cue_sound: AudioStreamPlayer2D


func present(data: FailureData, origin: Vector2) -> void:
	# 1. Cause - the player character reacts in-world.
	var player := get_tree().get_first_node_in_group("player")
	if player != null and data.cause_cue != "none" and player.has_method("play_cause_cue"):
		player.play_cause_cue(data.cause_cue)

	# 2. Correction - the companion demonstrates the correct route.
	var companion := get_tree().get_first_node_in_group("companion")
	if companion != null and companion.has_method("demonstrate"):
		companion.demonstrate(data.world_points(origin), Config.DEMO_DURATION)

	if cue_sound != null:
		cue_sound.global_position = origin
		cue_sound.play()


func clear() -> void:
	var companion := get_tree().get_first_node_in_group("companion")
	if companion != null and companion.has_method("return_to_player"):
		companion.return_to_player()
