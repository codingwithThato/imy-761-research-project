extends AnimatableBody2D
## A platform that oscillates between two points. The player must time a
## jump onto it, ride it across, then time a jump off - too early or too
## late in either direction drops them into the hazard below.
##
## AnimatableBody2D with sync_to_physics carries a riding CharacterBody2D
## automatically - no custom carry logic needed.

@export var travel: Vector2 = Vector2(200, 0)  ## offset from start to far point
@export var one_way_duration: float = 1.5

var _start := Vector2.ZERO


func _ready() -> void:
	sync_to_physics = true
	_start = position
	var tw := create_tween().set_loops()
	tw.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tw.tween_property(self, "position", _start + travel, one_way_duration)\
		.set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "position", _start, one_way_duration)\
		.set_trans(Tween.TRANS_SINE)


## The position this platform was authored at (before it starts oscillating).
## Demo routes author their board/disembark points assuming the platform is
## here - callers re-derive a live offset from this reference and reapply it
## to the platform's current position, so the demonstration tracks wherever
## the platform actually is instead of a stale, pre-authored guess.
func get_rest_position() -> Vector2:
	return _start
