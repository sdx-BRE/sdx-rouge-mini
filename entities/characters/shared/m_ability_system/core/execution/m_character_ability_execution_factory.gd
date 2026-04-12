class_name MCharacterAbilityExecutionFactory extends RefCounted

var _target_context: MCharacterAbilityExecutionAimingContext
var _setup_context: MCharacterAbilityExecutionSetupContext
var _execute_context: MCharacterAbilityExecutionExecuteContext

func _init(
	target_context: MCharacterAbilityExecutionAimingContext,
	setup_context: MCharacterAbilityExecutionSetupContext,
	execute_context: MCharacterAbilityExecutionExecuteContext,
) -> void:
	_target_context = target_context
	_setup_context = setup_context
	_execute_context = execute_context

func create(
	state: MCharacterAbilityExecution.Phase,
	data: MCharacterAbilityData,
	exec: MCharacterAbilityExecution,
) -> MCharacterAbilityExecutionBase:
	match state:
		MCharacterAbilityExecution.Phase.Aiming:
			return McharacterAbilityExecutionAiming.new(exec, data.targeting, _target_context)
		MCharacterAbilityExecution.Phase.Setup:
			return MCharacterAbilityExecutionSetup.new(exec, data, _setup_context)
		MCharacterAbilityExecution.Phase.Execute:
			return MCharacterAbilityExecutionExecute.new(exec, data, _execute_context)
		MCharacterAbilityExecution.Phase.Recover:
			push_error("[MCharacterAbilityExecutionFactory.create()]: 'Recover' must be implemented!")	
	return null
