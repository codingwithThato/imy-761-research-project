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


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false


func show_path(world_points: PackedVector2Array) -> void:
	_world_points = world_points
	_showing = true
	visible = true
	queue_redraw()


func hide_path() -> void:
	_showing = false
	visible = false
	_world_points = PackedVector2Array()
	queue_redraw()


func _process(_delta: float) -> void:
	# Redraw while visible so the arrow tracks the camera.
	if _showing:
		queue_redraw()


func _draw() -> void:
	if not _showing or _world_points.size() < 2:
		return

	var xf := get_viewport().get_canvas_transform()
	var pts := PackedVector2Array()
	for p in _world_points:
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
