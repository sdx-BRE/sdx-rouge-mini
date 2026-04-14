class_name CharacterAbilityManager extends RefCounted

var _execution: CharacterAbilityExecuter

func _init(
	execution: CharacterAbilityExecuter
) -> void:
	_execution = execution

func handle_ability_action(
	ability: CharacterAbility,
	state: CharacterAbilitySystem.TriggerState,
) -> void:
	match state:
		CharacterAbilitySystem.TriggerState.Press:
			_execution.start(ability)
		CharacterAbilitySystem.TriggerState.Release:
			_execution.release()

func is_handling_active_ability(event: InputEvent) -> bool:
	return _execution.handle_input(event)

func tick(delta: float) -> void:
	_execution.tick(delta)

func handle_animation_event() -> void:
	_execution.handle_animation_event()
