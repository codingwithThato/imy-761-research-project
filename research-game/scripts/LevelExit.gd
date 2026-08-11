extends Area2D
## Place at the end of a level. Transitions to the next scene on player
## contact. Leave `next_level` empty to end the sequence and return to the
## Launcher instead.

@export var next_level: PackedScene

var _triggered := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if _triggered or not body.is_in_group("player"):
		return
	_triggered = true
	if next_level != null:
		ScreenFade.change_scene(next_level)
	else:
		ScreenFade.change_scene(null, "res://Launcher.tscn")
