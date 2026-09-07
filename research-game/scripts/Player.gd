extends CharacterBody2D
## Minimal player controller. Add to group "player".
##
## Tune SPEED / JUMP_VELOCITY / GRAVITY until the jump feels fair. Spend real
## time here: if the controller feels floaty or unresponsive, your frustration
## scores will be measuring your physics, not your manipulation.
##
## Exposes the three methods FailureController calls:
##   set_locked(bool), respawn_at(Vector2), play_cause_cue(String)

@export var speed: float = 220.0
@export var jump_velocity: float = -420.0
@export var gravity: float = 1100.0
@export var coyote_time: float = 0.10      ## forgiveness after leaving a ledge
@export var jump_buffer: float = 0.10      ## forgiveness for early jump press
@onready var sprite: CanvasItem = $AnimatedSprite2D

var _locked := false
var _coyote := 0.0
var _buffer := 0.0

## Action tracking for failure classification (see get_failure_context()).
var _last_jump_time := -INF
var _last_jump_x := 0.0
var _jumped_since_grounded := false
var _last_move_dir := 0.0


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta: float) -> void:
	if _locked:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y += gravity * delta
		_coyote -= delta
	else:
		_coyote = coyote_time
		_jumped_since_grounded = false

	if Input.is_action_just_pressed("ui_accept"):
		_buffer = jump_buffer
	else:
		_buffer -= delta

	if _buffer > 0.0 and _coyote > 0.0:
		velocity.y = jump_velocity
		_buffer = 0.0
		_coyote = 0.0
		_play("jump")
		_last_jump_time = Time.get_ticks_msec() / 1000.0
		_last_jump_x = global_position.x
		_jumped_since_grounded = true

	var dir := Input.get_axis("ui_left", "ui_right")
	velocity.x = dir * speed
	if dir != 0.0:
		_last_move_dir = dir
	if sprite != null and dir != 0.0:
		sprite.scale.x = absf(sprite.scale.x) * signf(dir)

	move_and_slide()

	if is_on_floor():
		_play("run" if absf(velocity.x) > 1.0 else "idle")


## Called by FailureController at the start and end of every failure.
func set_locked(value: bool) -> void:
	_locked = value
	if value:
		velocity = Vector2.ZERO


## Called by FailureController after the feedback window closes.
func respawn_at(pos: Vector2) -> void:
	global_position = pos
	velocity = Vector2.ZERO
	show()
	_play("idle")


## Called by FailureController for any failure where she falls out of view
## (pit/gap/edge). A brief universal reaction before she vanishes - not a
## cause cue, so it plays identically in both conditions.
func play_fall_reaction() -> void:
	_play("stumble")


## DIEGETIC condition only: the in-world reaction that communicates the cause.
func play_cause_cue(cue: String) -> void:
	match cue:
		"stumble":
			_play("stumble")
		"recoil":
			_play("recoil")
		"overshoot":
			_play("overshoot")
		_:
			pass


## Called by Hazard.gd at the moment of contact, to classify what the player
## actually did before this failure (see FailureData.Mistake).
func get_failure_context() -> Dictionary:
	return {
		"jumped": _jumped_since_grounded,
		"jump_x": _last_jump_x,
		"jump_time": _last_jump_time,
		"move_dir": _last_move_dir,
	}


func _play(anim: String) -> void:
	if sprite != null and sprite.has_method("play"):
		sprite.call("play", anim)
