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

	draw_polyline(pts, line_colour, line_width, true)

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
