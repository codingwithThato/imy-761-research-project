extends Area2D
## Put this on every spike, pit trigger, and moving-platform gap.
##
## The cause is TAGGED AT THE SOURCE, not inferred from physics. Each hazard
## carries one or more FailureData variants, authored in the editor, tagged
## by which mistake they address. This is reliable and takes minutes;
## inferring cause from velocity vectors is a rabbit hole that will eat your
## build week - so classification below is two comparisons against
## author-set numbers (expected_takeoff_range / expected_direction), not
## physics guessing.
##
## Setup per hazard:
##   1. Add this script to an Area2D with a CollisionShape2D.
##   2. Add one or more FailureData resources to failure_variants, each
##      tagged with the Mistake it addresses (FailureData.mistake).
##   3. Fill in cause_id, cause_message, cause_cue per variant.
##   4. Author demo_points as offsets from THIS node's position.
##   5. For jump-timing hazards (gaps/spikes/platforms), set
##      expected_takeoff_range to the world-x window (offset from this
##      node) a correct jump should start in. For direction hazards
##      (e.g. "walked off the start ledge"), set hazard_kind to "direction"
##      and expected_direction to the correct way of travel.
##
## A hazard with only one variant (tagged GENERIC or anything else) always
## falls back to it - existing single-variant hazards behave exactly as
## before.

@export var failure_variants: Array[FailureData] = []
@export_enum("jump_obstacle", "direction") var hazard_kind: String = "jump_obstacle"
## World-x offsets from this hazard's position; only used when
## hazard_kind == "jump_obstacle". A jump whose takeoff x falls before this
## range is JUMPED_TOO_EARLY, after it is JUMPED_TOO_LATE, inside it is
## GENERIC (timing was fine, something else went wrong).
@export var expected_takeoff_range: Vector2 = Vector2(-40, -10)
## +1 (right) or -1 (left); only used when hazard_kind == "direction".
@export var expected_direction: float = 1.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if failure_variants.is_empty():
		push_warning("Hazard '%s' has no FailureData variants assigned." % name)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	var ctx: Dictionary = body.get_failure_context() if body.has_method("get_failure_context") else {}
	var mistake := _classify(ctx)
	var data := _select_variant(mistake)
	FailureController.trigger_failure(data, global_position, ctx)


## Reads the player's pre-failure action (see Player.get_failure_context())
## and turns it into a Mistake. Falls back to GENERIC if the body couldn't
## report a failure context.
func _classify(ctx: Dictionary) -> FailureData.Mistake:
	if ctx.is_empty():
		return FailureData.Mistake.GENERIC

	if hazard_kind == "direction":
		if signf(ctx.move_dir) != signf(expected_direction):
			return FailureData.Mistake.WRONG_DIRECTION
		return FailureData.Mistake.GENERIC

	if not ctx.jumped:
		return FailureData.Mistake.NO_JUMP
	var rel_x: float = ctx.jump_x - global_position.x
	if rel_x < expected_takeoff_range.x:
		return FailureData.Mistake.JUMPED_TOO_EARLY
	if rel_x > expected_takeoff_range.y:
		return FailureData.Mistake.JUMPED_TOO_LATE
	return FailureData.Mistake.GENERIC


## Picks the variant tagged with this mistake, falling back to the GENERIC
## variant, then to the first variant - so a hazard authored with only one
## FailureData (any tag) behaves exactly as before this system existed.
func _select_variant(mistake: FailureData.Mistake) -> FailureData:
	for v in failure_variants:
		if v.mistake == mistake:
			return v
	for v in failure_variants:
		if v.mistake == FailureData.Mistake.GENERIC:
			return v
	return failure_variants[0] if not failure_variants.is_empty() else null


## Helper for authoring: draws every variant's demo path in the editor so
## you can see the routes you are creating without running the game.
func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	for v in failure_variants:
		if v != null and v.demo_points.size() >= 2:
			draw_polyline(v.demo_points, Color(0.2, 1.0, 0.4, 0.8), 2.0)
