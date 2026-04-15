class_name CharacterAbilityExecutionFactory extends RefCounted

var _target_context: CharacterAbilityAimingContext
var _setup_context: CharacterAbilitySetupContext
var _execute_context: CharacterAbilityExecuteContext
var _recover_context: CharacterAbilityRecoverContext

func _init(
	target_context: CharacterAbilityAimingContext,
	setup_context: CharacterAbilitySetupContext,
	execute_context: CharacterAbilityExecuteContext,
	recover_context: CharacterAbilityRecoverContext,
) -> void:
	_target_context = target_context
	_setup_context = setup_context
	_execute_context = execute_context
	_recover_context = recover_context

func create(
	state: CharacterAbilityExecuter.Phase,
	ability: CharacterAbility,
	exec: CharacterAbilityExecuter,
) -> CharacterAbilityExecutionPhase:
	match state:
		CharacterAbilityExecuter.Phase.Aiming:
			return CharacterAbilityAimingPhase.new(exec, ability, _target_context)
		CharacterAbilityExecuter.Phase.Setup:
			return CharacterAbilitySetupPhase.new(exec, ability, _setup_context)
		CharacterAbilityExecuter.Phase.Execute:
			return CharacterAbilityExecutePhase.new(exec, ability, _execute_context)
		CharacterAbilityExecuter.Phase.Recover:
			return CharacterAbilityRecoverPhase.new(exec, ability, _recover_context)
	return null
