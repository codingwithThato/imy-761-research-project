extends FailurePresenter
## NON-DIEGETIC condition.
##
## Scene layout expected:
##   CanvasLayer
##     NonDiegeticPresenter   (this script, group "non_diegetic_presenter")
##       Label                (assign to hud_label)
##       ArrowOverlay         (Control with ArrowOverlay.gd, assign to arrow)
##
## Conveys the SAME information as the diegetic presenter, through the
## interface instead of the world:
##   cause      -> data.cause_message as HUD text
##   correction -> the SAME data.demo_points drawn as a screen-space arrow
##
## The companion is still present in the level (it exists in both conditions)
## but stays neutral here - only its failure-moment behaviour differs.

@onready var hud_label: Label = $HUDLabel
@onready var arrow: Control = $ArrowOverlay
## Optional: a UI blip. Non-positional, unlike the diegetic cue sound.
@export var ui_sound: AudioStreamPlayer


func present(data: FailureData, origin: Vector2, context: Dictionary = {}) -> void:
	if hud_label != null:
		hud_label.text = data.cause_message
		hud_label.visible = true

	var world_points := data.effective_world_points(origin, context)
	if arrow != null and arrow.has_method("show_path"):
		arrow.show_path(world_points, context.get("platform"))

	# The companion stays neutral - it does NOT demonstrate in this condition.
	var companion := get_tree().get_first_node_in_group("companion")
	if companion != null and companion.has_method("stay_neutral"):
		# NON-DIEGETIC ONLY: stay_neutral() doesn't reposition her, so for a
		# hides_player hazard (pit/gap/edge) she'd otherwise sit wherever she
		# happened to be standing when the player fell out of view - which,
		# since her normal follow spot only guarantees "near the player", can
		# be hovering over the gap itself, for the whole feedback window.
		# Snap her to whichever END of the same route the arrow is drawing
		# she's currently closer to - the near side for a normal approach,
		# but the far side too if the player somehow failed jumping backward
		# into the hazard, since this reads off her actual position rather
		# than assuming forward approach the way the authored start point
		# would. Always right next to the hazard she just failed at, never a
		# distant, possibly off-screen checkpoint that would read as "she
		# died too". The diegetic condition has no equivalent of this and
		# isn't affected: demonstrate() already relocates her to the
		# hazard's own route regardless.
		if data.hides_player and companion is Node2D and world_points.size() >= 2:
			var near: Vector2 = world_points[0]
			var far: Vector2 = world_points[world_points.size() - 1]
			var current: Vector2 = companion.global_position
			companion.global_position = near if current.distance_to(near) <= current.distance_to(far) else far
		companion.stay_neutral()

	if ui_sound != null:
		ui_sound.play()


func clear() -> void:
	if hud_label != null:
		hud_label.visible = false
	if arrow != null and arrow.has_method("hide_path"):
		arrow.hide_path()

	var companion := get_tree().get_first_node_in_group("companion")
	if companion != null and companion.has_method("return_to_player"):
		companion.return_to_player()
