class_name MCharacterAbilityManager extends RefCounted

var _execution: MCharacterAbilityExecution

func _init(
	execution: MCharacterAbilityExecution
) -> void:
	_execution = execution

func try_activate(
	ability: MCharacterAbility,
	state: MCharacterAbilitySystem.TriggerState,
) -> void:
	_execution.start(ability, state)

func is_handling_active_ability(event: InputEvent) -> bool:
	return _execution.handle_input(event)

func tick(delta: float) -> void:
	_execution.tick(delta)
