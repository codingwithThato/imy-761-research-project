extends Node2D
## The companion entity. Add to group "companion".
##
## CRITICAL FOR THE STUDY: this node is present in BOTH conditions, from
## level one, at all times. Its presence is not the manipulation. Only its
## behaviour AT THE MOMENT OF FAILURE differs:
##   diegetic     -> demonstrate() : walks the correct route
##   non-diegetic -> stay_neutral(): idles while the HUD delivers the same info
##
## If it only appeared on death, it would read as a failure-triggered UI
## affordance in costume, and the condition would arguably be spatial rather
## than diegetic (Fagerholt and Lorentzon, 2009).

@export var follow_offset: Vector2 = Vector2(-40.0, 24.0)  ## ground-level, dog-sized companion
@export var follow_smoothing: float = 5.0
## How much to round corners of the demonstration route, as a fraction of
## each leg's length (0-0.5). Keeps the dog's path a natural curve instead
## of straight legs meeting at hard angles.
@export_range(0.0, 0.5) var corner_radius: float = 0.3
@export var corner_smoothness: int = 6
@onready var sprite: CanvasItem = $AnimatedSprite2D

enum State { FOLLOWING, DEMONSTRATING, NEUTRAL, HOLDING }

var _state: State = State.FOLLOWING
var _player: Node2D = null
var _tween: Tween = null

## How long the player has gone without a movement/jump input, while following.
var _player_idle_time := 0.0


func _ready() -> void:
	add_to_group("companion")
	_player = get_tree().get_first_node_in_group("player")
	FailureController.failure_started.connect(_on_failure_started)


## The player is locked (and, for a hides_player hazard, about to fall out of
## view) the instant a failure starts - but demonstrate()/stay_neutral() only
## take over a beat later, after FEEDBACK_ONSET (and, for pit/gap/edge
## hazards, FALL_REACT_TIME on top of that). Left in FOLLOWING for that
## window, she'd keep lerping toward the player's now-frozen position, which
## can be well above ground level mid-fall-arc (the fall/pit trigger zones
## are tall) - reading as her floating up to meet a body that isn't moving
## anymore. Freezing her here, in place, the instant the failure starts
## closes that window; whichever state takes over next overrides this fine.
func _on_failure_started(_data: FailureData) -> void:
	if _state == State.FOLLOWING:
		_state = State.HOLDING
		_play_anim("idle")


## Below this, the dog is close enough to its follow spot to be considered
## "caught up" and idles instead of running.
const CATCH_UP_DISTANCE := 12.0

## How long the player must go without any movement/jump input before the
## companion sits down beside them instead of standing idle - a bit of
## charm for a player who stops to look around, not a gameplay signal.
const IDLE_SIT_DELAY := 5.0

## How far past a solid hazard's edge to keep the companion clear of it, so
## she never ends up standing (or, with the idle-sit above, sitting) on top
## of something dangerous just because the player parked nearby.
const HAZARD_CLEARANCE := 20.0


func _process(delta: float) -> void:
	if _state != State.FOLLOWING:
		_player_idle_time = 0.0
		return
	if _player == null or not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player")
		return
	var target: Vector2 = _player.global_position + follow_offset

	# Riding a moving platform: lock to it instead of lerp-chasing a target
	# that never stops moving - the lag reads as her shuffling back and
	# forth in place rather than standing still beside the player.
	var riding_platform: Node2D = null
	if _player.has_method("get_standing_platform"):
		riding_platform = _player.get_standing_platform()
	if riding_platform != null:
		_player_idle_time = 0.0
		_face(target.x - global_position.x)
		_play_anim("idle")
		global_position = target
		return

	target.x = _clear_of_solid_hazards(target.x)
	_face(target.x - global_position.x)

	if absf(Input.get_axis("ui_left", "ui_right")) < 0.01 and not Input.is_action_pressed("ui_accept"):
		_player_idle_time += delta
	else:
		_player_idle_time = 0.0

	var caught_up := global_position.distance_to(target) <= CATCH_UP_DISTANCE
	if caught_up and _player_idle_time >= IDLE_SIT_DELAY:
		_play_anim("sit")
	else:
		_play_anim("run" if not caught_up else "idle")
	global_position = global_position.lerp(target, clampf(follow_smoothing * delta, 0.0, 1.0))


## Pushes a follow-target x clear of any "solid" hazard (one with a visible
## Sprite2D - spikes today; any future hazard authored with real rendered
## geometry gets this for free) so she never ends up standing, or now
## sitting, on top of something dangerous just because the player parked
## nearby. Only checks x: every hazard sits at ground level, same height she
## always follows at, so a 1D check is enough.
func _clear_of_solid_hazards(target_x: float) -> float:
	for hazard in get_tree().get_nodes_in_group("hazard"):
		if not (hazard is Node2D) or not hazard.has_node("Sprite2D"):
			continue
		var shape_node: CollisionShape2D = hazard.get_node_or_null("CollisionShape2D")
		if shape_node == null or not (shape_node.shape is RectangleShape2D):
			continue
		var half_width: float = shape_node.shape.size.x * 0.5 + HAZARD_CLEARANCE
		var center_x: float = hazard.global_position.x + shape_node.position.x
		if absf(target_x - center_x) < half_width:
			var left_edge := center_x - half_width
			var right_edge := center_x + half_width
			target_x = left_edge if absf(target_x - left_edge) < absf(target_x - right_edge) else right_edge
	return target_x


## Vertical delta (px) a leg needs before it reads as part of a jump arc
## rather than a flat run - matches the arcs authored into demo_points.
const JUMP_ARC_HEIGHT := 20.0

## Brief hold, in the "idle" pose, right where a route switches from a flat
## run-up into a jump arc - reads as the character planting her feet and
## timing the leap, rather than gliding straight from a run pose into a
## jump pose. Only inserted at run->jump transitions, never jump->run.
const PRE_JUMP_PAUSE := 0.15

## NO_JUMP-style emphasis: instead of the brief PRE_JUMP_PAUSE, she turns to
## the player, barks, then crouches before leaping - a longer, more legible
## "there is a jump required here" beat. Each hold below is a separate pose.
## Held long enough to actually be caught by a first-time player, not just
## glimpsed - this is the whole point of the emphasis.
const BARK_HOLD := 0.7
const CROUCH_HOLD := 0.6

## JUMPED_TOO_EARLY: a clearly visible hold right at the abandoned point -
## where the player actually jumped - before she continues on to the real
## takeoff. Longer than PRE_JUMP_PAUSE precisely because this beat is doing
## the work of saying "not here", not just "here we go".
const ABANDONED_PAUSE := 0.45

## A "jump" group that isn't the route's LAST group is incidental scenery on
## the way to the real hazard (e.g. hopping spikes before the actual pitfall
## jump) - it never gets the emphasized bark/crouch beat (that beat belongs
## solely to the hazard actually being taught; playing it twice pushes the
## whole demonstration past Config.FEEDBACK_DURATION and the real jump gets
## cut off before it plays). It's still given extra time below so it reads
## as a deliberate hop rather than a blur.
const INCIDENTAL_JUMP_SLOWDOWN := 1.8

## MOVING PLATFORM: how long each leg of a platform ride takes. Approach and
## depart are quick hops; the ride itself is held long enough to clearly read
## as "waiting on/riding the platform" rather than a blink-and-miss-it beat.
## Total (1.8s) comfortably fits Config.FEEDBACK_DURATION (3.0s).
const PLATFORM_APPROACH_TIME := 0.35
const PLATFORM_HOP_UP_TIME := 0.25
const PLATFORM_RIDE_TIME := 1.0
const PLATFORM_DEPART_TIME := 0.35

## Used instead of PLATFORM_RIDE_TIME whenever the NO_JUMP bark/crouch beat
## plays before boarding - that beat alone adds ~1.3s, and without trimming
## the ride hold the whole sequence would blow past Config.FEEDBACK_DURATION
## and get cut off before the depart hop plays (the same failure mode fixed
## for composite gap+spike routes - see INCIDENTAL_JUMP_SLOWDOWN above).
const PLATFORM_RIDE_TIME_EMPHASIZED := 0.5


## DIEGETIC: walk the correct route through the obstacle.
##
## The route is split into contiguous "run" (flat) and "jump" (vertical arc)
## groups of legs, each played with the matching pose - a route that starts
## with a flat leg before rising will show her running up to the takeoff
## point, pausing, then leaping, instead of one static pose glided across
## the whole path. When emphasize_hesitation is true, the pause at a
## run->jump transition is replaced with the longer face-player/bark/crouch
## beat instead of the default brief idle hold. pause_at_index (an index
## into world_points, from FailureData.pause_at_index()) marks a point the
## route already runs through - e.g. the JUMPED_TOO_EARLY abandoned point -
## where she should pause before continuing, independent of run/jump kind.
func demonstrate(world_points: PackedVector2Array, duration: float, emphasize_hesitation: bool = false, pause_at_index: int = -1, platform: Node2D = null) -> void:
	if world_points.size() < 2:
		return
	if platform != null and is_instance_valid(platform) and world_points.size() >= 4:
		_demonstrate_platform_ride(world_points, platform, emphasize_hesitation, pause_at_index)
		return
	_state = State.DEMONSTRATING
	_set_translucent(true)
	_face(world_points[world_points.size() - 1].x - world_points[0].x)

	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()

	global_position = world_points[0]

	var total_length := 0.0
	for i in range(1, world_points.size()):
		total_length += world_points[i].distance_to(world_points[i - 1])
	if total_length <= 0.0:
		return

	var groups := _group_legs_by_kind(world_points)
	groups = _split_group_at_index(groups, pause_at_index)
	for g_index in range(groups.size()):
		var group: Dictionary = groups[g_index]
		var group_points: PackedVector2Array = group.points
		var is_incidental_jump: bool = group.kind == "jump" and g_index < groups.size() - 1

		if g_index > 0 and groups[g_index - 1].kind == "run" and group.kind == "jump":
			if emphasize_hesitation and not is_incidental_jump:
				_tween.tween_callback(_face_player)
				_tween.tween_callback(_play_anim.bind("bark"))
				_tween.tween_interval(BARK_HOLD)
				_tween.tween_callback(_play_anim.bind("sit"))
				_tween.tween_interval(CROUCH_HOLD)
				var forward: float = group_points[group_points.size() - 1].x - group_points[0].x
				_tween.tween_callback(_face.bind(forward))
			else:
				_tween.tween_callback(_play_anim.bind("idle"))
				_tween.tween_interval(PRE_JUMP_PAUSE)
		elif g_index > 0 and group.get("pause_before", false):
			_tween.tween_callback(_play_anim.bind("idle"))
			_tween.tween_interval(ABANDONED_PAUSE)
		_tween.tween_callback(_play_anim.bind(group.kind))

		var group_length := 0.0
		for i in range(1, group_points.size()):
			group_length += group_points[i].distance_to(group_points[i - 1])
		var group_time: float = duration * (group_length / total_length)
		if is_incidental_jump:
			group_time *= INCIDENTAL_JUMP_SLOWDOWN

		var smooth_points := _round_corners(group_points)
		var smooth_total := 0.0
		for i in range(1, smooth_points.size()):
			smooth_total += smooth_points[i].distance_to(smooth_points[i - 1])
		if smooth_total <= 0.0:
			continue
		for i in range(1, smooth_points.size()):
			var leg_length: float = smooth_points[i].distance_to(smooth_points[i - 1])
			var leg_time: float = group_time * (leg_length / smooth_total)
			_tween.tween_property(self, "global_position", smooth_points[i], leg_time)\
				.set_trans(Tween.TRANS_SINE)


## DIEGETIC, moving-platform variant: board, ride, and disembark the ACTUAL
## platform node wherever it currently is, rather than tweening through a
## static pre-authored path. The platform keeps oscillating on its own timer
## throughout a failure (it is never paused), so a fixed route drawn assuming
## it sits at its rest position would drift out of sync with the visible
## platform - reading as the dog gliding through empty air instead of
## interacting with it.
##
## Uses a SINGLE ride anchor, centred on the platform body itself, offset
## only vertically to its surface height (the interior demo_points' average
## y, relative to the platform's rest y). This is deliberately not an offset
## that also carries any x component: the platform's sprite/collision are
## centred on its own origin (see Level4/5.tscn - no position override on
## either), so x=0 is always the platform's true centre regardless of where
## it currently is in its cycle. The interior demo_points span most of the
## platform's whole travel range (they were authored to trace the full ride
## visually), so averaging their x too - an earlier version of this method
## did - lands the anchor near the midpoint of the OSCILLATION RANGE, which
## reads as "off to the side of wherever the platform actually is" instead
## of "on the platform". Reapplied to platform.global_position every frame.
func _demonstrate_platform_ride(world_points: PackedVector2Array, platform: Node2D, emphasize_hesitation: bool = false, pause_at_index: int = -1) -> void:
	_state = State.DEMONSTRATING
	_set_translucent(true)

	if _tween != null and _tween.is_valid():
		_tween.kill()

	var start: Vector2 = world_points[0]
	var end: Vector2 = world_points[world_points.size() - 1]
	var rest: Vector2 = platform.get_rest_position() if platform.has_method("get_rest_position") else platform.global_position

	# An EARLY-jump waypoint (see below) is a ground-level detour for the
	# abandoned-point beat, not a real ride point - exclude it from the
	# surface-height average so this variant anchors to the same ride
	# height as every other one.
	var interior_start := 1
	if pause_at_index > 0:
		interior_start = pause_at_index + 1
	var interior_y_sum := 0.0
	for i in range(interior_start, world_points.size() - 1):
		interior_y_sum += world_points[i].y
	var surface_y: float = interior_y_sum / float(world_points.size() - 1 - interior_start)
	var ride_offset := Vector2(0.0, surface_y - rest.y)

	global_position = start
	_face((platform.global_position + ride_offset).x - start.x)

	# Same pre-board beat every other hazard type gets: NO_JUMP's bark/crouch,
	# JUMPED_TOO_EARLY's abandoned-point pause, or a brief default hold -
	# platforms used to skip this entirely and look identical regardless of
	# what the player actually did.
	var used_early_detour := false
	if pause_at_index > 0 and pause_at_index < world_points.size() - 1:
		used_early_detour = true
		var abandoned: Vector2 = world_points[pause_at_index]
		var resume: Vector2 = Vector2(world_points[pause_at_index + 1].x, start.y)
		_play_anim("run")
		await _tween_to(abandoned, PLATFORM_APPROACH_TIME * 0.5)
		if _state != State.DEMONSTRATING or not is_instance_valid(platform):
			return
		_play_anim("idle")
		await get_tree().create_timer(ABANDONED_PAUSE).timeout
		if _state != State.DEMONSTRATING or not is_instance_valid(platform):
			return
		_play_anim("run")
		await _tween_to(resume, PLATFORM_APPROACH_TIME * 0.5)
	elif emphasize_hesitation:
		_face_player()
		_play_anim("bark")
		await get_tree().create_timer(BARK_HOLD).timeout
		if _state != State.DEMONSTRATING or not is_instance_valid(platform):
			return
		_play_anim("sit")
		await get_tree().create_timer(CROUCH_HOLD).timeout
		_face((platform.global_position + ride_offset).x - global_position.x)
	else:
		_play_anim("idle")
		await get_tree().create_timer(PRE_JUMP_PAUSE).timeout
	if _state != State.DEMONSTRATING or not is_instance_valid(platform):
		return

	_play_anim("jump")
	await _arc_land_on_platform(platform, ride_offset, PLATFORM_APPROACH_TIME)
	if _state != State.DEMONSTRATING or not is_instance_valid(platform):
		return

	# Ride: glued to the platform's LIVE position continuously from the
	# instant she lands - including the brief "found her footing" beat, not
	# just the main hold. A static (non-tracking) wait for that beat used to
	# freeze her at the spot she landed on while the platform kept moving
	# underneath her, so she'd drift off-centre for that moment and then
	# have to snap back once the tracking loop below read the platform's
	# position fresh - this removes that seam by tracking through both.
	_play_anim("idle")
	var t := 0.0
	var ride_time: float = PLATFORM_RIDE_TIME_EMPHASIZED if emphasize_hesitation and not used_early_detour else PLATFORM_RIDE_TIME
	var hold_time: float = PLATFORM_HOP_UP_TIME + ride_time
	while t < hold_time:
		if _state != State.DEMONSTRATING or not is_instance_valid(platform):
			return
		global_position = platform.global_position + ride_offset
		await get_tree().process_frame
		t += get_process_delta_time()

	if _state != State.DEMONSTRATING or not is_instance_valid(platform):
		return
	global_position = platform.global_position + ride_offset

	# Depart at the correct moment - jump off toward the far ledge, from
	# wherever the platform actually carried her to.
	_face(end.x - global_position.x)
	_play_anim("jump")
	await _arc_glide_to(end, PLATFORM_DEPART_TIME)
	if _state != State.DEMONSTRATING:
		return
	_play_anim("idle")


## Simple point-to-point ground move, awaited - used for the small run
## detours in the platform-ride's JUMPED_TOO_EARLY abandoned-point beat.
func _tween_to(target: Vector2, time: float) -> void:
	if time <= 0.0:
		global_position = target
		return
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "global_position", target, time).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(time).timeout


## Jumps onto the platform, tracking its LIVE position every frame instead
## of aiming at a point computed once up front. The platform keeps moving
## for the whole ~0.35s of this hop, so a target snapshotted at the start
## drifts out from under her as she rises and falls - invisible mid-air
## (there's nothing to compare it against up there), then reading as a hard
## "appearing on the platform" pop the instant the next phase reads the
## platform's position fresh and jumps her onto it.
##
## Chases the live target with a deadline-aware lerp (each step's weight is
## dt/remaining-time, so it always closes the CURRENT gap by `time`) rather
## than re-interpolating from the fixed launch point with a frac that just
## grows 0->1. That version could visibly run forward then backward: if the
## platform swings back toward the launch side mid-hop (common right around
## its turnaround, exactly when a mistimed jump tends to happen), the target
## drifting back toward the fixed start shrinks frac*(target-from) even as
## frac keeps growing, so the interpolated position could rise then fall
## back before the hop finished - a real, reproducible glitch, not a one-off.
## Chasing the live target frame-to-frame only ever moves toward wherever it
## currently is, so it only backtracks if the platform itself genuinely
## reverses that much - an honest reflection of the platform's real motion,
## which is the whole point of live-tracking in the first place.
func _arc_land_on_platform(platform: Node2D, ride_offset: Vector2, time: float, arc_height: float = 30.0) -> void:
	var ground_pos: Vector2 = global_position
	var t := 0.0
	while t < time:
		if _state != State.DEMONSTRATING or not is_instance_valid(platform):
			return
		var frac: float = clampf(t / time, 0.0, 1.0)
		var target_now: Vector2 = platform.global_position + ride_offset
		_face(target_now.x - global_position.x)
		var dt: float = get_process_delta_time()
		var weight: float = clampf(dt / maxf(time - t, 0.001), 0.0, 1.0)
		ground_pos = ground_pos.lerp(target_now, weight)
		var lift: float = sin(frac * PI) * arc_height
		global_position = ground_pos - Vector2(0.0, lift)
		await get_tree().process_frame
		t += dt
	if _state != State.DEMONSTRATING or not is_instance_valid(platform):
		return
	global_position = platform.global_position + ride_offset


## Tweens through a shallow raised midpoint rather than straight to `target`,
## then reuses _round_corners() (the same smoothing the main route-tween
## already applies elsewhere) so the two straight legs read as one rounded
## arc - a jump should rise and fall, not slide diagonally in a straight
## line. Used by the platform-ride sequence, which needs to await between
## legs rather than queue a whole route onto one tween up front (each leg's
## start point isn't known until the previous leg, which may be tracking a
## moving platform, has actually finished). Waits on a timer rather than the
## tween's own `finished` signal - killing a tween early (e.g.
## return_to_player() interrupting mid-demo) does not reliably emit it,
## which would otherwise leave this coroutine suspended forever.
func _arc_glide_to(target: Vector2, time: float, arc_height: float = 30.0) -> void:
	var from: Vector2 = global_position
	var mid: Vector2 = from.lerp(target, 0.5) - Vector2(0.0, arc_height)
	var pts := _round_corners(PackedVector2Array([from, mid, target]))

	if _tween != null and _tween.is_valid():
		_tween.kill()
	_tween = create_tween()
	var total := 0.0
	for i in range(1, pts.size()):
		total += pts[i].distance_to(pts[i - 1])
	if total > 0.0:
		for i in range(1, pts.size()):
			var leg_length: float = pts[i].distance_to(pts[i - 1])
			var leg_time: float = time * (leg_length / total)
			_tween.tween_property(self, "global_position", pts[i], leg_time)\
				.set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(time).timeout


## Splits a route into contiguous runs of same-kind legs ("run" for flat
## legs, "jump" for legs with a vertical delta past JUMP_ARC_HEIGHT), each
## carrying the slice of points that make up that stretch. Corner rounding
## is applied within a group, never across a run/jump boundary, so the
## takeoff point itself stays a sharp, pausable joint.
func _group_legs_by_kind(points: PackedVector2Array) -> Array:
	var kinds: Array[String] = []
	for i in range(1, points.size()):
		kinds.append("jump" if absf(points[i].y - points[i - 1].y) > JUMP_ARC_HEIGHT else "run")

	var groups: Array[Dictionary] = []
	var start_idx := 0
	for i in range(1, kinds.size()):
		if kinds[i] != kinds[i - 1]:
			groups.append({"kind": kinds[i - 1], "points": points.slice(start_idx, i + 1)})
			start_idx = i
	groups.append({"kind": kinds[kinds.size() - 1], "points": points.slice(start_idx, points.size())})
	return groups


## Further splits whichever group contains split_index (an index into the
## original points array) into two groups of the same kind, right after
## that point - so a pause can be inserted there independent of any
## run/jump kind change. The second half is tagged "pause_before" so the
## caller knows to insert a hold before it. No-op if split_index already
## falls on an existing group boundary (e.g. no waypoint was inserted).
func _split_group_at_index(groups: Array, split_index: int) -> Array:
	if split_index <= 0:
		return groups
	var out: Array[Dictionary] = []
	var running_index := 0
	for group in groups:
		var group_points: PackedVector2Array = group.points
		var start_idx := running_index
		var end_idx := running_index + group_points.size() - 1
		if split_index > start_idx and split_index < end_idx:
			var local_split := split_index - start_idx
			out.append({"kind": group.kind, "points": group_points.slice(0, local_split + 1)})
			out.append({"kind": group.kind, "points": group_points.slice(local_split, group_points.size()), "pause_before": true})
		else:
			out.append(group)
		running_index = end_idx
	return out


## Replaces each interior corner with a short quadratic-bezier arc so the
## route reads as a smooth curve instead of straight legs meeting at hard
## angles. Same technique as ArrowOverlay's rounding, so the diegetic and
## non-diegetic paths read as visually consistent shapes.
func _round_corners(points: PackedVector2Array) -> PackedVector2Array:
	if points.size() < 3:
		return points
	var out := PackedVector2Array()
	out.append(points[0])
	for i in range(1, points.size() - 1):
		var prev: Vector2 = points[i - 1]
		var corner: Vector2 = points[i]
		var next: Vector2 = points[i + 1]
		var in_vec := corner - prev
		var out_vec := next - corner
		var a: Vector2 = corner - in_vec * corner_radius
		var b: Vector2 = corner + out_vec * corner_radius
		out.append(a)
		for step in range(1, corner_smoothness):
			var t := float(step) / float(corner_smoothness)
			var p0 := a.lerp(corner, t)
			var p1 := corner.lerp(b, t)
			out.append(p0.lerp(p1, t))
		out.append(b)
	out.append(points[points.size() - 1])
	return out


## NON-DIEGETIC: stay put and neutral while the overlay does the work.
func stay_neutral() -> void:
	_state = State.NEUTRAL
	_set_translucent(false)
	_play_anim("sit")


## Called at the end of the feedback window in both conditions.
func return_to_player() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	_set_translucent(false)
	_play_anim("idle")
	_state = State.FOLLOWING


## Marks the demonstration as visually distinct from normal following.
## Lowering alpha alone blends the sprite toward the (dark) background and
## reads as "the dog got darker" rather than "ghosted" - so this brightens
## the colour slightly while keeping it mostly opaque instead.
func _set_translucent(on: bool) -> void:
	if sprite != null:
		sprite.modulate = Color(1.3, 1.3, 1.3, 0.85) if on else Color.WHITE


## Flips the sprite to face the direction of travel. Matches Player.gd's
## left/right flip so the dog doesn't visibly walk backward.
func _face(dir: float) -> void:
	if sprite != null and absf(dir) > 1.0:
		sprite.scale.x = absf(sprite.scale.x) * signf(dir)


## Turns to face the player, for the NO_JUMP hesitation beat. The player may
## be hidden (pit/gap hazards) at this point - she still turns toward where
## the player is, same as calling out to someone off-screen.
func _face_player() -> void:
	if _player != null and is_instance_valid(_player):
		_face(_player.global_position.x - global_position.x)


@warning_ignore("shadowed_variable_base_class")
func _play_anim(name: String) -> void:
	if sprite != null and sprite.has_method("play"):
		sprite.call("play", name)
