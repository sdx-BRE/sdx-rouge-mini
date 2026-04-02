class_name CharacterAbilityManager extends RefCounted

var _channeled_handler: ChanneledAbilityHandler
var _instant_handler: InstantAbilityHandler
var _phased_handler: PhasedAbilityHandler

func _init(
	channeled_handler: ChanneledAbilityHandler,
	instant_handler: InstantAbilityHandler,
	phased_handler: PhasedAbilityHandler,
) -> void:
	_channeled_handler = channeled_handler
	_instant_handler = instant_handler
	_phased_handler = phased_handler

func try_activate(ability: CharacterAbility, state: CharacterAbilitySystem.TriggerState) -> void:
	var handler := ability.resolve_handler(_get_handlers())
	
	if handler == null:
		push_warning("[WARN][CharacterAbilityResolver.try_activate]: ability handler not found")
		return
	
	handler.setup(ability).try_activate(state)

func is_handling_active_ability(event: InputEvent) -> bool:
	return _phased_handler.is_input_handled(event)

func execute_buffered_ability() -> void:
	_phased_handler.execute_buffered_ability()

func tick(delta: float) -> void:
	_phased_handler.tick(delta)
	_channeled_handler.tick(delta)

func _get_handlers() -> Array[CharacterAbilityHandler]:
	return [
		_channeled_handler,
		_instant_handler,
		_phased_handler,
	]
