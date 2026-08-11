extends CanvasLayer
## AUTOLOAD as "ScreenFade".
##
## Fades to black, swaps the scene, fades back in. Used by LevelExit so
## level-to-level transitions don't read as a hard, disorienting cut.
## Equivalence note: this is purely cosmetic and runs identically regardless
## of condition - it happens outside the failure-feedback pipeline entirely.

const FADE_TIME := 0.25

var _rect: ColorRect


func _ready() -> void:
	layer = 100
	_rect = ColorRect.new()
	_rect.color = Color(0, 0, 0, 0)
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_rect)


## Fades out, changes to next_scene (a PackedScene) or scene_path (a res://
## path) - pass exactly one - then fades back in.
func change_scene(next_scene: PackedScene = null, scene_path: String = "") -> void:
	var out_tween := create_tween()
	out_tween.tween_property(_rect, "color:a", 1.0, FADE_TIME)
	await out_tween.finished

	if next_scene != null:
		get_tree().change_scene_to_packed.call_deferred(next_scene)
	else:
		get_tree().change_scene_to_file.call_deferred(scene_path)

	await get_tree().process_frame
	await get_tree().process_frame

	var in_tween := create_tween()
	in_tween.tween_property(_rect, "color:a", 0.0, FADE_TIME)
