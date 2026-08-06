extends Control
## Launcher screen. Set participant code and condition here, then hand the
## mouse to the participant.
##
## Scene layout expected:
##   Control (this script)
##     LineEdit        -> code_field
##     OptionButton    -> condition_picker   (item 0 = Diegetic, 1 = Non-diegetic)
##     Button          -> start_button
##
## IMPORTANT: this screen must not be reachable once play begins, or a curious
## participant will find it and flip their own condition.

@export var first_level: PackedScene

@onready var code_field: LineEdit = $CenterContainer/VBoxContainer/CodeField
@onready var condition_picker: OptionButton = $CenterContainer/VBoxContainer/ConditionPicker
@onready var start_button: Button = $CenterContainer/VBoxContainer/StartButton


func _ready() -> void:
	if condition_picker != null:
		condition_picker.clear()
		condition_picker.add_item("Diegetic", 0)
		condition_picker.add_item("Non-diegetic", 1)
		condition_picker.select(0)
	if start_button != null:
		start_button.pressed.connect(_on_start)


func _on_start() -> void:
	if code_field != null:
		Config.participant_code = code_field.text.strip_edges()

	if condition_picker != null:
		Config.condition = (Config.Condition.DIEGETIC
			if condition_picker.get_selected_id() == 0
			else Config.Condition.NON_DIEGETIC)

	# Print the timing table once per session - useful evidence for Materials.
	Config.dump_timings()
	print("participant: %s" % Config.participant_code)

	if first_level != null:
		get_tree().change_scene_to_packed(first_level)
