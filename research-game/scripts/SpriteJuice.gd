extends Control
## Placeholder-art "juice" — drives visible motion on whatever this script is
## attached to (a ColorRect, Sprite2D, whatever) via Tween, exposing the same
## play(anim_name) interface a real AnimatedSprite2D would.
##
## Swap this out for AnimatedSprite2D + SpriteFrames later; Player.gd and
## Companion.gd only care that `sprite` has a play(String) method, so nothing
## else needs to change.
##
## Each cue is a DISTINCT, readable motion — that's the point: a playtester
## must be able to tell stumble/recoil/overshoot apart from silhouette alone.
##   idle      - gentle breathing scale, no tint
##   run       - quick side-to-side lean
##   jump      - anticipation squash then stretch
##   stumble   - trips forward, pitches down, dusty tint
##   recoil    - snaps backward, red tint (hit something)
##   overshoot - leans too far forward, overcorrects back, cyan tint

var _tween: Tween
var _current_loop := ""

var _base_scale := Vector2.ONE
var _base_modulate := Color.WHITE


func _ready() -> void:
	_base_scale = scale
	_base_modulate = modulate


func play(anim: String) -> void:
	match anim:
		"idle", "run":
			if _current_loop == anim:
				return
			_current_loop = anim
			_reset_transform()
			_start_loop(anim)
		_:
			_current_loop = ""
			_reset_transform()
			_one_shot(anim)


func _reset_transform() -> void:
	_kill_tween()
	scale = _base_scale
	rotation = 0.0
	position = Vector2.ZERO
	modulate = _base_modulate


func _start_loop(anim: String) -> void:
	_tween = create_tween().set_loops()
	match anim:
		"idle":
			_tween.tween_property(self, "scale", _base_scale * Vector2(1.0, 1.05), 0.6)\
				.set_trans(Tween.TRANS_SINE)
			_tween.tween_property(self, "scale", _base_scale, 0.6)\
				.set_trans(Tween.TRANS_SINE)
		"run":
			_tween.tween_property(self, "rotation", deg_to_rad(-5.0), 0.1)\
				.set_trans(Tween.TRANS_SINE)
			_tween.tween_property(self, "rotation", deg_to_rad(5.0), 0.1)\
				.set_trans(Tween.TRANS_SINE)


func _one_shot(anim: String) -> void:
	_tween = create_tween()
	match anim:
		"jump":
			_tween.tween_property(self, "scale", _base_scale * Vector2(1.25, 0.7), 0.08)\
				.set_trans(Tween.TRANS_SINE)
			_tween.tween_property(self, "scale", _base_scale * Vector2(0.8, 1.25), 0.10)\
				.set_trans(Tween.TRANS_SINE)
			_tween.tween_property(self, "scale", _base_scale, 0.2)\
				.set_trans(Tween.TRANS_ELASTIC)

		"stumble":
			_tween.tween_property(self, "modulate", Color(0.85, 0.7, 0.4), 0.05)
			_tween.parallel().tween_property(self, "rotation", deg_to_rad(25.0), 0.10)\
				.set_trans(Tween.TRANS_QUAD)
			_tween.parallel().tween_property(self, "position:x", 8.0, 0.10)
			_tween.tween_property(self, "rotation", deg_to_rad(-10.0), 0.12)
			_tween.tween_property(self, "rotation", 0.0, 0.2)\
				.set_trans(Tween.TRANS_ELASTIC)
			_tween.parallel().tween_property(self, "position:x", 0.0, 0.25)
			_tween.parallel().tween_property(self, "modulate", _base_modulate, 0.3)

		"recoil":
			_tween.tween_property(self, "modulate", Color(1.0, 0.4, 0.4), 0.05)
			_tween.parallel().tween_property(self, "position:x", -16.0, 0.06)\
				.set_trans(Tween.TRANS_QUAD)
			_tween.parallel().tween_property(self, "rotation", deg_to_rad(-12.0), 0.06)
			_tween.tween_property(self, "position:x", 0.0, 0.25)\
				.set_trans(Tween.TRANS_ELASTIC)
			_tween.parallel().tween_property(self, "rotation", 0.0, 0.25)\
				.set_trans(Tween.TRANS_ELASTIC)
			_tween.parallel().tween_property(self, "modulate", _base_modulate, 0.3)

		"overshoot":
			_tween.tween_property(self, "modulate", Color(0.5, 0.85, 1.0), 0.05)
			_tween.parallel().tween_property(self, "position:x", 20.0, 0.16)\
				.set_trans(Tween.TRANS_SINE)
			_tween.parallel().tween_property(self, "scale:x", _base_scale.x * 1.3, 0.16)
			_tween.tween_property(self, "position:x", 0.0, 0.22)\
				.set_trans(Tween.TRANS_BACK)
			_tween.parallel().tween_property(self, "scale:x", _base_scale.x, 0.22)\
				.set_trans(Tween.TRANS_BACK)
			_tween.parallel().tween_property(self, "modulate", _base_modulate, 0.3)


func _kill_tween() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
