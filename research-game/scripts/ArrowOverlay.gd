extends Control
## Draws the corrective path as a screen-space arrow on the UI layer.
##
## This is the non-diegetic twin of the companion's demonstration: it traces
## exactly the same points, but painted on the interface rather than existing
## in the world. Keep the look flat and obviously "UI" - that contrast is the
## manipulation.

@export var line_colour: Color = Color(1.0, 0.85, 0.2, 0.95)
@export var line_width: float = 4.0
@export var head_size: float = 14.0
## How much to round corners, as a fraction of each segment's length (0-0.5).
@export_range(0.0, 0.5) var corner_radius: float = 0.35
## Points used to approximate each rounded corner's curve.
@export var corner_smoothness: int = 8

var _world_points: PackedVector2Array = PackedVector2Array()
var _showing := false
## Set when the route rides a MovingPlatform (see Hazard.platform_path). When
## present, the board/disembark portion of the path is recomputed from the
## platform's LIVE position every redraw instead of the static authored
## points - same fix as Companion._demonstrate_platform_ride(), applied to
## the arrow instead of the dog.
var _platform: Node2D = null
## Index of a JUMPED_TOO_EARLY waypoint inserted into _world_points (see
## FailureData.pause_at_index()), or -1 if none. That waypoint is a
## ground-level detour point, not a real ride point - _draw_platform_path()
## needs this to exclude it from the platform's surface-height average, same
## as Companion._demonstrate_platform_ride() does.
var _pause_at_index := -1

## Height (px) a leg needs to rise before it counts as part of a jump arc
## rather than a flat run-up. Matches Companion.gd's JUMP_ARC_HEIGHT so both
## presenters agree on which part of a shared route is "the jump".
const JUMP_ARC_HEIGHT := 20.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false


func show_path(world_points: PackedVector2Array, platform: Node2D = null, pause_at_index: int = -1) -> void:
	_world_points = world_points
	_platform = platform
	_pause_at_index = pause_at_index
	_showing = true
	visible = true
	queue_redraw()


func hide_path() -> void:
	_showing = false
	visible = false
	_world_points = PackedVector2Array()
	_platform = null
	_pause_at_index = -1
	queue_redraw()


func _process(_delta: float) -> void:
	# Redraw while visible so the arrow tracks the camera.
	if _showing:
		queue_redraw()


func _draw() -> void:
	if not _showing or _world_points.size() < 2:
		return

	if _platform != null and is_instance_valid(_platform) and _world_points.size() >= 4:
		_draw_platform_path()
		return

	var trimmed := _trim_to_final_jump(_world_points)
	if trimmed.size() < 2:
		return

	var xf := get_viewport().get_canvas_transform()
	var pts := PackedVector2Array()
	for p in trimmed:
		pts.append(xf * p)

	var smooth_pts := _round_corners(pts)
	draw_polyline(smooth_pts, line_colour, line_width, true)
	# Round every joint/cap so the path never shows a hard square edge.
	for p in smooth_pts:
		draw_circle(p, line_width * 0.5, line_colour)

	# Arrowhead at the final point.
	var tip: Vector2 = pts[pts.size() - 1]
	var prev: Vector2 = pts[pts.size() - 2]
	var dir := (tip - prev).normalized()
	if dir == Vector2.ZERO:
		return
	var left := dir.rotated(deg_to_rad(150.0)) * head_size
	var right := dir.rotated(deg_to_rad(-150.0)) * head_size
	draw_colored_polygon(
		PackedVector2Array([tip, tip + left, tip + right]),
		line_colour
	)
	# Soften the head's corners so it reads as a rounded dart, not a chevron.
	draw_circle(tip, head_size * 0.12, line_colour)
	draw_circle(tip + left, head_size * 0.2, line_colour)
	draw_circle(tip + right, head_size * 0.2, line_colour)


## Drops everything before the LAST jump arc in the route. The arrow is a
## correction cue for the hazard's own jump; a leading run-up exists only so
## the diegetic companion has room to run (and, for JUMPED_TOO_EARLY, pause
## at the abandoned point) - not meaningful as a static screen arrow, and the
## "cause" side of that distinction is already carried by the HUD text.
## Some routes now hop an incidental obstacle (e.g. spikes) before the real
## hazard's jump - see Companion.gd's is_incidental_jump - which the shared
## demo_points route the arrow reads from can't help but include too. Only
## the LAST jump arc is the hazard being taught; an earlier hop and the run
## legs around it are scenery, same reasoning as the plain leading run-up,
## so trimming to the start of the trailing jump run drops both at once and
## keeps the arrow a single clean arc even when the underlying route has two.
## A route with no jump leg at all (e.g. a direction hazard) is returned
## unchanged - there is no arc to isolate, so the whole route is the cue.
func _trim_to_final_jump(points: PackedVector2Array) -> PackedVector2Array:
	var is_jump_leg: Array[bool] = []
	for i in range(1, points.size()):
		is_jump_leg.append(absf(points[i].y - points[i - 1].y) > JUMP_ARC_HEIGHT)

	var last_jump_start := -1
	for i in range(is_jump_leg.size() - 1, -1, -1):
		if is_jump_leg[i]:
			last_jump_start = i
		elif last_jump_start != -1:
			break
	if last_jump_start == -1:
		return points
	return points.slice(last_jump_start, points.size())


## MOVING PLATFORM: recomputes the ride anchor from the platform's LIVE
## position every redraw (same rest-offset trick as
## Companion._demonstrate_platform_ride() - see its comment for why this
## offset carries no x component, only the surface-height y) so the marker
## always sits on top of the actual platform sprite, wherever it currently
## is, instead of a static point that drifts out of sync with a platform
## that never stops moving. Draws explicit cues per the "where to stand /
## when to jump / where to move" ask: a hollow ring at the live ride anchor
## ("stand here, and note this moves with the platform"), then a line +
## arrowhead from that same live point to the landing spot ("jump here, to
## here").
func _draw_platform_path() -> void:
	var rest: Vector2 = _platform.get_rest_position() if _platform.has_method("get_rest_position") else _platform.global_position

	# A JUMPED_TOO_EARLY waypoint (see _pause_at_index above) is a
	# ground-level detour, not a real ride point - exclude it from the
	# surface-height average so this variant's marker anchors to the same
	# ride height as every other one, same fix as
	# Companion._demonstrate_platform_ride().
	var interior_start := 1
	if _pause_at_index > 0:
		interior_start = _pause_at_index + 1
	var interior_y_sum := 0.0
	for i in range(interior_start, _world_points.size() - 1):
		interior_y_sum += _world_points[i].y
	var surface_y: float = interior_y_sum / float(_world_points.size() - 1 - interior_start)
	var ride_offset := Vector2(0.0, surface_y - rest.y)
	var start: Vector2 = _world_points[0]
	var end: Vector2 = _world_points[_world_points.size() - 1]
	var anchor: Vector2 = _platform.global_position + ride_offset

	var xf := get_viewport().get_canvas_transform()
	var p_start := xf * start
	var p_anchor := xf * anchor
	var p_end := xf * end

	var approach := _round_corners(PackedVector2Array([p_start, p_anchor]))
	var depart := _round_corners(PackedVector2Array([p_anchor, p_end]))
	draw_polyline(approach, line_colour, line_width, true)
	draw_polyline(depart, line_colour, line_width, true)
	for p in approach:
		draw_circle(p, line_width * 0.5, line_colour)
	for p in depart:
		draw_circle(p, line_width * 0.5, line_colour)

	# "Stand here" - hollow ring at the live ride anchor.
	draw_arc(p_anchor, head_size * 0.9, 0.0, TAU, 24, line_colour, line_width * 0.8, true)

	# Arrowhead pointing from the ride anchor at the actual landing spot.
	var dir := (p_end - p_anchor).normalized()
	if dir == Vector2.ZERO:
		return
	var left := dir.rotated(deg_to_rad(150.0)) * head_size
	var right := dir.rotated(deg_to_rad(-150.0)) * head_size
	draw_colored_polygon(
		PackedVector2Array([p_end, p_end + left, p_end + right]),
		line_colour
	)
	draw_circle(p_end, head_size * 0.12, line_colour)
	draw_circle(p_end + left, head_size * 0.2, line_colour)
	draw_circle(p_end + right, head_size * 0.2, line_colour)


## Replaces each interior corner with a short quadratic-bezier arc so a
## right-angle route reads as a smooth curve instead of a boxy path.
func _round_corners(pts: PackedVector2Array) -> PackedVector2Array:
	if pts.size() < 3:
		return pts
	var out := PackedVector2Array()
	out.append(pts[0])
	for i in range(1, pts.size() - 1):
		var prev: Vector2 = pts[i - 1]
		var corner: Vector2 = pts[i]
		var next: Vector2 = pts[i + 1]
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
	out.append(pts[pts.size() - 1])
	return out
