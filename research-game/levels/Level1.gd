extends Node2D
## Level 1 - single pit, one checkpoint. Proves the failure pipeline end to end.

@onready var _player: Node2D = $Player


func _ready() -> void:
	FailureController.set_spawn(_player.global_position)
