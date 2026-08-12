extends Node2D
## Temporary animation smoke test — cycles Cait through every animation
## so they can be screenshotted and eyeballed. Not part of the game.

var anims := ["idle", "run", "jump", "stumble", "recoil", "overshoot"]
var idx := 0
var timer := 0.0

@onready var cait: CharacterBody2D = $Cait
@onready var sprite: AnimatedSprite2D = $Cait/AnimatedSprite2D


func _ready() -> void:
	cait.set_locked(true)
	sprite.play(anims[0])
	print("PLAYING: ", anims[0])


func _process(delta: float) -> void:
	timer += delta
	if timer > 1.5:
		timer = 0.0
		idx += 1
		if idx >= anims.size():
			print("DONE_ALL_ANIMS")
			get_tree().quit()
			return
		sprite.play(anims[idx])
		print("PLAYING: ", anims[idx])
