extends Node2D
## Level 2 - gap, spikes, gap. Exercises all three cause cues (stumble,
## recoil, overshoot) across two checkpoints.

@onready var _player: Node2D = $Player


func _ready() -> void:
	FailureController.set_spawn(_player.global_position)
