extends Area2D
## Place at roughly 20% intervals through each level.
##
## EQUIVALENCE NOTE: checkpoints work identically in both conditions. Recovery
## cost is where the old punitive/informative asymmetry lived (full restart vs
## checkpoint) - it must NOT vary here, or the manipulation stops being
## channel-only.

@export var respawn_offset: Vector2 = Vector2(0.0, -16.0)

var _claimed := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if _claimed or not body.is_in_group("player"):
		return
	_claimed = true
	FailureController.set_checkpoint(global_position + respawn_offset)
