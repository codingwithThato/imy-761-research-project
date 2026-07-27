class_name FailurePresenter
extends Node
## Base class for both presenters. Defines the interface FailureController
## calls. Subclasses override present() and clear() only - they must not
## introduce their own timing, or the conditions stop being equivalent.

## Show the failure feedback. Called exactly Config.FEEDBACK_ONSET seconds
## after the death, in both conditions.
func present(_data: FailureData, _origin: Vector2) -> void:
	push_error("FailurePresenter.present() not overridden.")


## Hide the feedback. Called exactly Config.FEEDBACK_DURATION seconds after
## present(), in both conditions.
func clear() -> void:
	push_error("FailurePresenter.clear() not overridden.")
