class_name FailureData
extends Resource
## The single source of failure information for BOTH conditions.
##
## Attach one of these to each hazard in the editor. The diegetic presenter
## renders `demo_points` as the companion walking the correct route; the
## non-diegetic presenter renders THE SAME `demo_points` as an overlay arrow
## and shows `cause_message` as HUD text.
##
## Because both presenters read the same resource, they cannot convey
## different information. That is the orthogonality constraint enforced in
## the data model.

## Short identifier for this failure type, e.g. "pit_late_jump".
@export var cause_id: String = ""

## Plain-language statement of what went wrong AND what to do instead.
## Used verbatim as HUD text in the non-diegetic condition. The diegetic
## condition must convey this same content through the cause cue + demo.
## e.g. "Jumped too late - take off earlier"
@export_multiline var cause_message: String = ""

## The correct route through this obstacle, as offsets from the hazard's
## global position. Author these by dragging points in the editor.
## Both conditions render these identical points.
@export var demo_points: PackedVector2Array = PackedVector2Array()

## Which in-world reaction the player character plays in the DIEGETIC
## condition to communicate the cause. Pick "none" for no cue.
## (Godot does not allow an empty option in @export_enum, so "none" is the
## placeholder for "no cue".)
@export_enum("none", "stumble", "recoil", "overshoot") var cause_cue: String = "none"

## Whether the player is hidden while this failure plays out. True for
## hazards where she falls out of view (pits, gaps, the start edge) - there
## is nothing useful to see mid-fall, and being frozen mid-air while the
## companion demonstrates elsewhere reads as broken. False for hazards where
## she stays put and reacts in view (e.g. spikes), where the reaction cue
## itself needs to be visible. Identical in both conditions.
@export var hides_player: bool = true

## Which specific mistake this variant addresses. A hazard can hold several
## FailureData variants, one per mistake; Hazard.gd classifies the player's
## actual pre-failure action and picks the matching one, so the message and
## the demo route are both about what actually happened.
enum Mistake { NO_JUMP, JUMPED_TOO_EARLY, JUMPED_TOO_LATE, WRONG_DIRECTION, GENERIC }

## GENERIC is the catch-all: timing/direction was fine but the attempt still
## failed some other way, and the fallback for hazards that only have one
## authored variant so far.
@export var mistake: Mistake = Mistake.GENERIC

## DIEGETIC only: when true, the companion's pre-jump pause (see
## Companion.demonstrate()) is replaced with a longer face-player/bark/
## crouch beat instead of the default brief idle hold. For NO_JUMP variants,
## where the point is "there is a jump required here", not just timing.
@export var emphasize_hesitation: bool = false


## Converts the authored offsets into world-space points.
func world_points(origin: Vector2) -> PackedVector2Array:
	return _to_world(demo_points, origin)


## Like world_points(), but for a JUMPED_TOO_EARLY variant with a live
## jump_x in context, inserts a waypoint at the player's actual (clamped)
## takeoff x between the route's first two authored points - so the
## companion visibly runs PAST where the player actually jumped before
## leaping from the correct spot, instead of a fixed illustrative point.
##
## Both presenters call this (not world_points() directly) so the diegetic
## route and the non-diegetic arrow stay identical per attempt - the
## orthogonality constraint holds for the dynamic case the same way it does
## for the static one.
func effective_world_points(origin: Vector2, context: Dictionary) -> PackedVector2Array:
	return _to_world(_effective_offset_points(origin, context), origin)


## Index into effective_world_points()'s result where the companion should
## pause - having just run past the abandoned point - before continuing on
## to the real takeoff. -1 if this attempt has no such point (e.g. context
## was missing jump_x, or this variant isn't JUMPED_TOO_EARLY). Derived from
## whether a waypoint was actually inserted, not just from `mistake`, so it
## always agrees with effective_world_points().
func pause_at_index(origin: Vector2, context: Dictionary) -> int:
	if mistake == Mistake.JUMPED_TOO_EARLY \
			and _effective_offset_points(origin, context).size() > demo_points.size():
		return 1
	return -1


func _effective_offset_points(origin: Vector2, context: Dictionary) -> PackedVector2Array:
	if mistake != Mistake.JUMPED_TOO_EARLY or not context.has("jump_x") or demo_points.size() < 2:
		return demo_points

	var start: Vector2 = demo_points[0]
	var next: Vector2 = demo_points[1]
	var lo: float = minf(start.x, next.x)
	var hi: float = maxf(start.x, next.x)
	var waypoint := Vector2(clampf(context.jump_x - origin.x, lo, hi), start.y)

	var points := PackedVector2Array([start, waypoint])
	for i in range(1, demo_points.size()):
		points.append(demo_points[i])
	return points


func _to_world(points: PackedVector2Array, origin: Vector2) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in points:
		out.append(origin + p)
	return out


func is_valid() -> bool:
	return cause_id != "" and cause_message != "" and demo_points.size() >= 2
