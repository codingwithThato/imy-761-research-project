extends Node2D
## Level 4 - introduces the moving platform: a wide gap only crossable by
## riding a platform that oscillates between the two ledges. Mistiming the
## jump on or off drops the player into the hazard below.

@onready var _player: Node2D = $Player


func _ready() -> void:
	FailureController.set_spawn(_player.global_position)
