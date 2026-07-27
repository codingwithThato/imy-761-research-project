extends Area2D
## Put this on every spike, pit trigger, and moving-platform gap.
##
## The cause is TAGGED AT THE SOURCE, not inferred from physics. Each hazard
## carries its own FailureData, authored in the editor. This is reliable and
## takes minutes; inferring cause from velocity vectors is a rabbit hole that
## will eat your build week.
##
## Setup per hazard:
##   1. Add this script to an Area2D with a CollisionShape2D.
##   2. Create a new FailureData resource in the inspector.
##   3. Fill in cause_id, cause_message, cause_cue.
##   4. Author demo_points as offsets from THIS node's position.

@export var failure_data: FailureData


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if failure_data == null:
		push_warning("Hazard '%s' has no FailureData assigned." % name)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	FailureController.trigger_failure(failure_data, global_position)


## Helper for authoring: draws the demo path in the editor so you can see
## the route you are creating without running the game.
func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	if failure_data == null or failure_data.demo_points.size() < 2:
		return
	draw_polyline(failure_data.demo_points, Color(0.2, 1.0, 0.4, 0.8), 2.0)
