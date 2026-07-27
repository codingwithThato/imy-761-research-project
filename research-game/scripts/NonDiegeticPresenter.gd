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

@export var hud_label: Label
@export var arrow: Control
## Optional: a UI blip. Non-positional, unlike the diegetic cue sound.
@export var ui_sound: AudioStreamPlayer


func present(data: FailureData, origin: Vector2) -> void:
	if hud_label != null:
		hud_label.text = data.cause_message
		hud_label.visible = true

	if arrow != null and arrow.has_method("show_path"):
		arrow.show_path(data.world_points(origin))

	# The companion stays neutral - it does NOT demonstrate in this condition.
	var companion := get_tree().get_first_node_in_group("companion")
	if companion != null and companion.has_method("stay_neutral"):
		companion.stay_neutral()

	if ui_sound != null:
		ui_sound.play()


func clear() -> void:
	if hud_label != null:
		hud_label.visible = false
	if arrow != null and arrow.has_method("hide_path"):
		arrow.hide_path()
