class_name AbilityResolver extends RefCounted

var _cast_handler: AbilityHandlerCast
var _instant_handler: AbilityHandlerInstant

func _init(
	cast_handler: AbilityHandlerCast,
	instant_handler: AbilityHandlerInstant,
) -> void:
	_cast_handler = cast_handler
	_instant_handler = instant_handler

func resolve(ability: BaseAbility) -> AbilityHandler:
	if ability is CastAbility:
		return _resolve_cast(ability)
	elif ability is InstantAbility:
		return _resolve_instant(ability)
	
	push_error("[Error][AbilityResolver.resolve()] - failed to resolve ability: ", ability.get_class())
	return null

func execute_cast() -> void:
	_cast_handler.execute()

func _resolve_cast(ability: CastAbility) -> AbilityHandlerCast:
	return _cast_handler.setup(ability)

func _resolve_instant(ability: InstantAbility) -> AbilityHandlerInstant:
	return _instant_handler.setup(ability)
