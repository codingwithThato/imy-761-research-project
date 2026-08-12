# Failure feedback prototype — script setup

Godot 4 / GDScript. Scripts for the diegetic vs non-diegetic failure feedback study.

## 1. Autoloads

Project → Project Settings → Autoload. Add these two, in this order:

| Path | Node name |
|---|---|
| `res://scripts/Config.gd` | `Config` |
| `res://scripts/FailureController.gd` | `FailureController` |

Order matters — `FailureController` reads `Config`.

## 2. Input map

Project → Project Settings → Input Map. The player script uses the built-in
actions `ui_left`, `ui_right`, `ui_accept`. Add a spacebar binding to
`ui_accept` if it isn't there already.

## 3. Groups

The controller finds things by group, so no per-level wiring code is needed.
Set these in the Node → Groups tab:

| Node | Group |
|---|---|
| Player | `player` |
| Companion | `companion` |
| DiegeticPresenter | `diegetic_presenter` |
| NonDiegeticPresenter | `non_diegetic_presenter` |

`Player.gd` and `Companion.gd` also add themselves in `_ready()` as a safety net.

## 4. Level scene structure

```
Level (Node2D)
├── Player            (CharacterBody2D, Player.gd, group "player")
├── Companion         (Node2D, Companion.gd, group "companion")
├── Camera2D
├── TileMap / platforms
├── Hazards
│   ├── PitTrigger    (Area2D, Hazard.gd + FailureData)
│   ├── Spikes01      (Area2D, Hazard.gd + FailureData)
│   └── PlatformGap   (Area2D, Hazard.gd + FailureData)
├── Checkpoints
│   ├── Checkpoint01  (Area2D, Checkpoint.gd)
│   └── Checkpoint02  (Area2D, Checkpoint.gd)
├── DiegeticPresenter (Node, DiegeticPresenter.gd, group "diegetic_presenter")
└── UI (CanvasLayer)
    └── NonDiegeticPresenter (Control, NonDiegeticPresenter.gd,
                              group "non_diegetic_presenter")
        ├── Label         → assign to hud_label
        └── ArrowOverlay  (Control, ArrowOverlay.gd) → assign to arrow
```

In the level's root script, call `FailureController.set_spawn(start_position)`
in `_ready()` so there's a respawn point before the first checkpoint.

## 5. Authoring a hazard

1. Area2D + CollisionShape2D, attach `Hazard.gd`.
2. In the inspector, `failure_data` → New FailureData.
3. Fill in:
   - `cause_id` — e.g. `pit_late_jump`
   - `cause_message` — what went wrong AND what to do, as short sentences
     with no em dashes, e.g. *"Jumped too late. Take off earlier."*
   - `cause_cue` — `stumble` / `recoil` / `overshoot`
   - `demo_points` — the correct route, as offsets from this hazard's position

`demo_points` is the important one: the companion walks it in the diegetic
condition and the overlay arrow traces the same points in the non-diegetic
condition. One data source, two channels.

## 6. Why it's built this way

Your methodology claims the two conditions differ only in delivery channel.
Three structural guarantees back that up:

1. **One pipeline.** `FailureController.trigger_failure()` runs the same code
   in both conditions. There is exactly one line that branches on condition —
   which presenter receives `present()`.
2. **One data source.** Both presenters read the same `FailureData`. They
   cannot convey different information.
3. **One set of timing constants.** Onset, duration, and respawn settle live in
   `Config` and are not per-condition.

That's the sentence your Materials chapter wants, and it's what a marker will
probe.

## 7. Equivalence audit (do this before submitting the beta)

Play both conditions back to back and confirm:

- [ ] identical respawn point after the same failure
- [ ] identical time from death to feedback appearing
- [ ] identical time feedback stays visible
- [ ] identical total time without input
- [ ] the same corrective route shown in both (same `demo_points`)
- [ ] the companion is visible in both conditions during normal play

`Config.dump_timings()` prints the timing table — paste the output into your
Materials section.

## 8. Keep demo paths editable

The pilot manipulation check exists to tune diegetic richness until
informativeness ratings match across conditions. Because `demo_points` is
editor data rather than code, tuning is dragging points, not rewriting scripts.
Keep it that way.
