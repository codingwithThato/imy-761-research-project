extends Node2D
## Level 3 - tight gap, spikes, tight gap, spikes, wide gap. Shorter landings
## and less room between hazards than Level 1/2.

@onready var _player: Node2D = $Player


func _ready() -> void:
	FailureController.set_spawn(_player.global_position)
