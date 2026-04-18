class_name AbilityExecutionFactory extends RefCounted

var _target_context: AbilityAimingContext
var _setup_context: AbilitySetupContext
var _execute_context: AbilityExecuteContext
var _recover_context: AbilityRecoverContext

func _init(
	target_context: AbilityAimingContext,
	setup_context: AbilitySetupContext,
	execute_context: AbilityExecuteContext,
	recover_context: AbilityRecoverContext,
) -> void:
	_target_context = target_context
	_setup_context = setup_context
	_execute_context = execute_context
	_recover_context = recover_context

func create(
	state: AbilityExecuter.Phase,
	ability: Ability,
	exec: AbilityExecuter,
) -> AbilityExecutionPhase:
	match state:
		AbilityExecuter.Phase.Aiming:
			return AbilityAimingPhase.new(exec, ability, _target_context)
		AbilityExecuter.Phase.Setup:
			return AbilitySetupPhase.new(exec, ability, _setup_context)
		AbilityExecuter.Phase.Execute:
			return AbilityExecutePhase.new(exec, ability, _execute_context)
		AbilityExecuter.Phase.Recover:
			return AbilityRecoverPhase.new(exec, ability, _recover_context)
	return null
