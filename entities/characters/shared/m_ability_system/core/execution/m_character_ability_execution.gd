class_name MCharacterAbilityExecution extends RefCounted

var _target_context: MCharacterAbilityExecutionTargetingContext

var _state: MCharacterAbilityExecutionBase
var _ability: MCharacterAbility

func _init(
	target_context: MCharacterAbilityExecutionTargetingContext,
) -> void:
	_target_context = target_context

func start(
	ability: MCharacterAbility,
	trigger_state: MCharacterAbilitySystem.TriggerState,
) -> void:
	if trigger_state == MCharacterAbilitySystem.TriggerState.Press:
		_ability = ability
		
		if _state != null:
			_state.cancel()
		
		_state = MCharacterAbilityExecutionTargeting.new(self, ability._data.targeting, _target_context)
		_state.start()

func handle_input(event: InputEvent) -> bool:
	if _state == null:
		return false
	
	return _state.handle_input(event)

func tick(delta: float) -> void:
	if _state == null:
		return
	
	_state.tick(delta)

func abort() -> void:
	_state = null
	_ability = null
