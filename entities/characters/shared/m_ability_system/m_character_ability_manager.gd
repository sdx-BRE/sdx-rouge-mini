class_name MCharacterAbilityManager extends RefCounted

var _execution: MCharacterAbilityExecution

func _init(
	execution: MCharacterAbilityExecution
) -> void:
	_execution = execution

func handle_ability_action(
	ability: MCharacterAbility,
	state: MCharacterAbilitySystem.TriggerState,
) -> void:
	match state:
		MCharacterAbilitySystem.TriggerState.Press:
			_execution.start(ability)
		MCharacterAbilitySystem.TriggerState.Release:
			_execution.release()

func is_handling_active_ability(event: InputEvent) -> bool:
	return _execution.handle_input(event)

func tick(delta: float) -> void:
	_execution.tick(delta)

func handle_animation_event() -> void:
	_execution.handle_animation_event()
