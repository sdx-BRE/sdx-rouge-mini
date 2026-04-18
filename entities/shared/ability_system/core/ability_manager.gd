class_name AbilityManager extends RefCounted

var _execution: AbilityExecuter

func _init(
	execution: AbilityExecuter
) -> void:
	_execution = execution

func handle_ability_action(
	ability: Ability,
	state: AbilitySystem.TriggerState,
) -> void:
	match state:
		AbilitySystem.TriggerState.Press:
			_execution.start(ability)
		AbilitySystem.TriggerState.Release:
			_execution.release()

func is_handling_active_ability(event: InputEvent) -> bool:
	return _execution.handle_input(event)

func tick(delta: float) -> void:
	_execution.tick(delta)

func handle_animation_event() -> void:
	_execution.handle_animation_event()
