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


## Converts the authored offsets into world-space points.
func world_points(origin: Vector2) -> PackedVector2Array:
	var out := PackedVector2Array()
	for p in demo_points:
		out.append(origin + p)
	return out


func is_valid() -> bool:
	return cause_id != "" and cause_message != "" and demo_points.size() >= 2
