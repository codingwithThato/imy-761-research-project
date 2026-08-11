extends Node2D
## Level 5 - the finale. Combines every hazard type from Levels 1-4 (tight
## gaps, spikes, two moving platforms at different speeds, wide overshoot
## jumps) into the longest, least forgiving sequence in the game. No level
## follows this one - LevelExit returns to the Launcher.

@onready var _player: Node2D = $Player


func _ready() -> void:
	FailureController.set_spawn(_player.global_position)
