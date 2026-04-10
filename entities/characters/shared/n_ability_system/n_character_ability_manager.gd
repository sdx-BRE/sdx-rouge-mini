class_name NCharacterAbilityManager extends RefCounted

var _channeled_handler: NCharacterAbilityHandlerChanneled
var _instant_handler: NCharacterAbilityHandlerInstant
var _phased_handler: NCharacterAbilityHandlerPhased

func _init(
	channeled_handler: NCharacterAbilityHandlerChanneled,
	instant_handler: NCharacterAbilityHandlerInstant,
	phased_handler: NCharacterAbilityHandlerPhased,
) -> void:
	_channeled_handler = channeled_handler
	_instant_handler = instant_handler
	_phased_handler = phased_handler

func try_activate(ability: NCharacterAbility, state: NCharacterAbilitySystem.TriggerState) -> void:
	var handler_idx := ability.get_handler()
	var handler: NCharacterAbilityHandler
	match handler_idx:
		NCharacterAbilityHandler.Execution.Channeled:
			handler = _channeled_handler
		NCharacterAbilityHandler.Execution.Phased:
			handler = _phased_handler
		NCharacterAbilityHandler.Execution.Instant:
			handler = _instant_handler
	
	handler.setup(ability)
	handler.try_activate(state)

func is_handling_active_ability(event: InputEvent) -> bool:
	return _phased_handler.is_input_handled(event)

func execute_buffered_ability() -> void:
	_phased_handler.execute_buffered_ability()

func tick(delta: float) -> void:
	_phased_handler.tick(delta)
	_channeled_handler.tick(delta)
