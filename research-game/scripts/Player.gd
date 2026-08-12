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

	if Input.is_action_just_pressed("ui_accept"):
		_buffer = jump_buffer
	else:
		_buffer -= delta

	if _buffer > 0.0 and _coyote > 0.0:
		velocity.y = jump_velocity
		_buffer = 0.0
		_coyote = 0.0
		_play("jump")

	var dir := Input.get_axis("ui_left", "ui_right")
	velocity.x = dir * speed
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
	_play("idle")


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


func _play(anim: String) -> void:
	if sprite != null and sprite.has_method("play"):
		sprite.call("play", anim)
