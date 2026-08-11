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

@export var follow_offset: Vector2 = Vector2(-40.0, -24.0)
@export var follow_smoothing: float = 5.0
@onready var sprite: CanvasItem = $ColorRect  ## AnimatedSprite2D/Sprite2D later; placeholder now

enum State { FOLLOWING, DEMONSTRATING, NEUTRAL }

var _state: State = State.FOLLOWING
var _player: Node2D = null
var _tween: Tween = null


func _ready() -> void:
	add_to_group("companion")
	_player = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	if _state != State.FOLLOWING:
		return
	if _player == null or not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
		return
	var target: Vector2 = _player.global_position + follow_offset
	global_position = global_position.lerp(target, clampf(follow_smoothing * delta, 0.0, 1.0))


## DIEGETIC: walk the correct route through the obstacle.
func demonstrate(world_points: PackedVector2Array, duration: float) -> void:
	if world_points.size() < 2:
		return
	_state = State.DEMONSTRATING
	_play_anim("run")
	_set_translucent(true)

	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()

	global_position = world_points[0]
	var leg_time: float = duration / float(world_points.size() - 1)
	for i in range(1, world_points.size()):
		_tween.tween_property(self, "global_position", world_points[i], leg_time)\
			.set_trans(Tween.TRANS_SINE)


## NON-DIEGETIC: stay put and neutral while the overlay does the work.
func stay_neutral() -> void:
	_state = State.NEUTRAL
	_set_translucent(false)
	_play_anim("idle")


## Called at the end of the feedback window in both conditions.
func return_to_player() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_set_translucent(false)
	_play_anim("idle")
	_state = State.FOLLOWING


func _set_translucent(on: bool) -> void:
	if sprite != null:
		sprite.modulate.a = 0.6 if on else 1.0


@warning_ignore("shadowed_variable_base_class")
func _play_anim(name: String) -> void:
	if sprite != null and sprite.has_method("play"):
		sprite.call("play", name)
