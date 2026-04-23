class_name AbilityManager extends RefCounted

var _execution: AbilityExecuter
var _tracked_action: StringName = &""

func _init(
	execution: AbilityExecuter
) -> void:
	_execution = execution
	_execution.finished.connect(_on_execution_finished)

func handle_ability_action(
	ability: Ability,
	state: AbilitySystem.TriggerState,
) -> void:
	match state:
		AbilitySystem.TriggerState.Press:
			_execution.start(ability)
		AbilitySystem.TriggerState.Release:
			_execution.release()

func is_any_ability_active() -> bool:
	return _execution.is_active()

func try_handle_tracked_release(event: InputEvent) -> bool:
	if _tracked_action != &"" and event.is_action_released(_tracked_action):
		_execution.release()
		_tracked_action = &""
		return true
	return false

func is_handling_active_ability(event: InputEvent) -> bool:
	var result := _execution.handle_input(event)

	if result.is_handled:
		_tracked_action = result.action

	return result.is_handled

func _on_execution_finished(_ability: Ability) -> void:
	_tracked_action = &""

func tick(delta: float) -> void:
	_execution.tick(delta)

func handle_animation_event() -> void:
	_execution.handle_animation_event()

func handle_hit_event(target: Node3D) -> void:
	_execution.notify_hit_event(target)
