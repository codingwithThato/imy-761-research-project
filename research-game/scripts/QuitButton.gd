extends Button
## Returns to the Launcher screen. Present identically in both conditions -
## not part of the failure-feedback pipeline, so it carries no timing or
## equivalence implications.


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	ScreenFade.change_scene(null, "res://Launcher.tscn")
