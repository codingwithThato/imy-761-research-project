extends Node
## AUTOLOAD as "FailureController".
##
## THE single failure pipeline. Both conditions run through this exact code.
## The ONLY branch on condition is which presenter object receives present().
## Everything else - detection, input lock, timing, respawn point, recovery
## cost - is shared and therefore identical by construction.
##
## Call from a hazard:  FailureController.trigger_failure(data, global_position)

signal failure_started(data: FailureData)
signal failure_finished()

var _busy := false
var _checkpoint := Vector2.ZERO
var _checkpoint_set := false

# Cached scene references, found lazily via groups.
var _player: Node = null
var _diegetic: Node = null
var _non_diegetic: Node = null


func _ready() -> void:
	# Clear cached refs whenever a new level loads.
	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node: Node) -> void:
	if node.is_in_group("player"):
		_player = node
		_diegetic = null
		_non_diegetic = null


## Levels call this at _ready() to set the initial respawn point.
func set_spawn(pos: Vector2) -> void:
	_checkpoint = pos
	_checkpoint_set = true


## Checkpoints call this when the player passes them.
func set_checkpoint(pos: Vector2) -> void:
	_checkpoint = pos
	_checkpoint_set = true


func _resolve_refs() -> void:
	if _player == null or not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
	if _diegetic == null or not is_instance_valid(_diegetic):
		_diegetic = get_tree().get_first_node_in_group("diegetic_presenter")
	if _non_diegetic == null or not is_instance_valid(_non_diegetic):
		_non_diegetic = get_tree().get_first_node_in_group("non_diegetic_presenter")


func _active_presenter() -> Node:
	if Config.condition == Config.Condition.DIEGETIC:
		return _diegetic
	return _non_diegetic


## The failure sequence. Identical in both conditions except line marked BRANCH.
func trigger_failure(data: FailureData, origin: Vector2) -> void:
	if _busy:
		return
	_busy = true

	_resolve_refs()

	if _player == null:
		push_error("FailureController: no node in group 'player'.")
		_busy = false
		return
	if data == null or not data.is_valid():
		push_error("FailureController: hazard has missing or invalid FailureData.")
		_busy = false
		return

	failure_started.emit(data)

	# 1. Lock input immediately (same in both conditions).
	if _player.has_method("set_locked"):
		_player.set_locked(true)

	# 1b. Fall-type failures: a brief stumble reaction, then hide her - same
	# in both conditions (see FailureData.hides_player).
	if data.hides_player:
		if _player.has_method("play_fall_reaction"):
			_player.play_fall_reaction()
		await get_tree().create_timer(Config.FALL_REACT_TIME).timeout
		if _player.has_method("hide"):
			_player.hide()

	# 2. Wait the shared onset delay.
	await get_tree().create_timer(Config.FEEDBACK_ONSET).timeout

	# 3. BRANCH - the only condition-dependent line in the whole pipeline.
	var presenter := _active_presenter()
	if presenter != null and presenter.has_method("present"):
		presenter.present(data, origin)
	else:
		push_warning("FailureController: no presenter found for condition %s."
			% Config.condition_name())

	# 4. Hold the feedback for the shared duration.
	await get_tree().create_timer(Config.FEEDBACK_DURATION).timeout

	if presenter != null and presenter.has_method("clear"):
		presenter.clear()

	# 5. Respawn at the last checkpoint (same recovery cost in both conditions).
	if _checkpoint_set and _player.has_method("respawn_at"):
		_player.respawn_at(_checkpoint)

	# 6. Settle, then return control.
	await get_tree().create_timer(Config.RESPAWN_SETTLE).timeout

	if _player.has_method("set_locked"):
		_player.set_locked(false)

	_busy = false
	failure_finished.emit()
