class_name CharacterAbilityExecutionFactory extends RefCounted

var _target_context: CharacterAbilityAimingContext
var _setup_context: CharacterAbilitySetupContext
var _execute_context: CharacterAbilityExecuteContext

func _init(
	target_context: CharacterAbilityAimingContext,
	setup_context: CharacterAbilitySetupContext,
	execute_context: CharacterAbilityExecuteContext,
) -> void:
	_target_context = target_context
	_setup_context = setup_context
	_execute_context = execute_context

func create(
	state: CharacterAbilityExecution.Phase,
	ability: CharacterAbility,
	exec: CharacterAbilityExecution,
) -> CharacterAbilityExecutionBase:
	match state:
		CharacterAbilityExecution.Phase.Aiming:
			return CharacterAbilityExecutionAiming.new(exec, ability._data, _target_context)
		CharacterAbilityExecution.Phase.Setup:
			return CharacterAbilityExecutionSetup.new(exec, ability._data, _setup_context)
		CharacterAbilityExecution.Phase.Execute:
			return CharacterAbilityExecutionExecute.new(exec, ability, _execute_context)
		CharacterAbilityExecution.Phase.Recover:
			push_error("[CharacterAbilityExecutionFactory.create()]: 'Recover' must be implemented!")	
	return null
