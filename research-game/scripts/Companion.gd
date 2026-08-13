extends Node2D
## The companion entity. Add to group "companion".
##
## CRITICAL FOR THE STUDY: this node is present in BOTH conditions, from
## level one, at all times. Its presence is not the manipulation. Only its
## behaviour AT THE MOMENT OF FAILURE differs:
##   diegetic     -> demonstrate() : walks the correct route
##   non-diegetic -> stay_neutral(): idles while the HUD delivers the same info
##
## If it only appeared on death, it would read as a failure-triggered UI
## affordance in costume, and the condition would arguably be spatial rather
## than diegetic (Fagerholt and Lorentzon, 2009).

@export var follow_offset: Vector2 = Vector2(-40.0, 24.0)  ## ground-level, dog-sized companion
@export var follow_smoothing: float = 5.0
## How much to round corners of the demonstration route, as a fraction of
## each leg's length (0-0.5). Keeps the dog's path a natural curve instead
## of straight legs meeting at hard angles.
@export_range(0.0, 0.5) var corner_radius: float = 0.3
@export var corner_smoothness: int = 6
@onready var sprite: CanvasItem = $AnimatedSprite2D

enum State { FOLLOWING, DEMONSTRATING, NEUTRAL }

var _state: State = State.FOLLOWING
var _player: Node2D = null
var _tween: Tween = null


func _ready() -> void:
	add_to_group("companion")
	_player = get_tree().get_first_node_in_group("player")


## Below this, the dog is close enough to its follow spot to be considered
## "caught up" and idles instead of running.
const CATCH_UP_DISTANCE := 12.0


func _process(delta: float) -> void:
	if _state != State.FOLLOWING:
		return
	if _player == null or not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
		return
	var target: Vector2 = _player.global_position + follow_offset
	_face(target.x - global_position.x)
	_play_anim("run" if global_position.distance_to(target) > CATCH_UP_DISTANCE else "idle")
	global_position = global_position.lerp(target, clampf(follow_smoothing * delta, 0.0, 1.0))


## Height (px) a route has to rise above its start point before it reads as
## a jump rather than a run - matches the arcs authored into demo_points.
const JUMP_ARC_HEIGHT := 20.0


## DIEGETIC: walk the correct route through the obstacle.
func demonstrate(world_points: PackedVector2Array, duration: float) -> void:
	if world_points.size() < 2:
		return
	_state = State.DEMONSTRATING
	_play_anim("jump" if _has_vertical_arc(world_points) else "run")
	_set_translucent(true)
	_face(world_points[world_points.size() - 1].x - world_points[0].x)

	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()

	var smooth_points := _round_corners(world_points)
	global_position = smooth_points[0]

	var total_length := 0.0
	for i in range(1, smooth_points.size()):
		total_length += smooth_points[i].distance_to(smooth_points[i - 1])
	if total_length <= 0.0:
		return

	for i in range(1, smooth_points.size()):
		var leg_length: float = smooth_points[i].distance_to(smooth_points[i - 1])
		var leg_time: float = duration * (leg_length / total_length)
		_tween.tween_property(self, "global_position", smooth_points[i], leg_time)\
			.set_trans(Tween.TRANS_SINE)


## Replaces each interior corner with a short quadratic-bezier arc so the
## route reads as a smooth curve instead of straight legs meeting at hard
## angles. Same technique as ArrowOverlay's rounding, so the diegetic and
## non-diegetic paths read as visually consistent shapes.
func _round_corners(points: PackedVector2Array) -> PackedVector2Array:
	if points.size() < 3:
		return points
	var out := PackedVector2Array()
	out.append(points[0])
	for i in range(1, points.size() - 1):
		var prev: Vector2 = points[i - 1]
		var corner: Vector2 = points[i]
		var next: Vector2 = points[i + 1]
		var in_vec := corner - prev
		var out_vec := next - corner
		var a: Vector2 = corner - in_vec * corner_radius
		var b: Vector2 = corner + out_vec * corner_radius
		out.append(a)
		for step in range(1, corner_smoothness):
			var t := float(step) / float(corner_smoothness)
			var p0 := a.lerp(corner, t)
			var p1 := corner.lerp(b, t)
			out.append(p0.lerp(p1, t))
		out.append(b)
	out.append(points[points.size() - 1])
	return out


## NON-DIEGETIC: stay put and neutral while the overlay does the work.
func stay_neutral() -> void:
	_state = State.NEUTRAL
	_set_translucent(false)
	_play_anim("sit")


## Called at the end of the feedback window in both conditions.
func return_to_player() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_set_translucent(false)
	_play_anim("idle")
	_state = State.FOLLOWING


## Marks the demonstration as visually distinct from normal following.
## Lowering alpha alone blends the sprite toward the (dark) background and
## reads as "the dog got darker" rather than "ghosted" - so this brightens
## the colour slightly while keeping it mostly opaque instead.
func _set_translucent(on: bool) -> void:
	if sprite != null:
		sprite.modulate = Color(1.3, 1.3, 1.3, 0.85) if on else Color.WHITE


## True if any point rises more than JUMP_ARC_HEIGHT above the route's start
## - i.e. the route has a jump-like arc rather than being a flat walk.
func _has_vertical_arc(points: PackedVector2Array) -> bool:
	var base_y: float = points[0].y
	for p in points:
		if base_y - p.y > JUMP_ARC_HEIGHT:
			return true
	return false


## Flips the sprite to face the direction of travel. Matches Player.gd's
## left/right flip so the dog doesn't visibly walk backward.
func _face(dir: float) -> void:
	if sprite != null and absf(dir) > 1.0:
		sprite.scale.x = absf(sprite.scale.x) * signf(dir)


@warning_ignore("shadowed_variable_base_class")
func _play_anim(name: String) -> void:
	if sprite != null and sprite.has_method("play"):
		sprite.call("play", name)
