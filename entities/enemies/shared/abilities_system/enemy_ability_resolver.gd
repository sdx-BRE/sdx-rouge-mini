class_name EnemyAbilityResolver extends RefCounted

var _cast_handler: EnemyAbilityHandlerCast
var _instant_handler: EnemyAbilityHandlerInstant

func _init(
	cast_handler: EnemyAbilityHandlerCast,
	instant_handler: EnemyAbilityHandlerInstant,
) -> void:
	_cast_handler = cast_handler
	_instant_handler = instant_handler

func resolve(ability: EnemyBaseAbility) -> EnemyAbilityHandler:
	if ability is EnemyCastAbility:
		return _resolve_cast(ability)
	elif ability is EnemyInstantAbility:
		return _resolve_instant(ability)
	
	push_error("[Error][AbilityResolver.resolve()] - failed to resolve ability: ", ability.get_class())
	return null

func execute_cast() -> void:
	_cast_handler.execute()

func _resolve_cast(ability: EnemyCastAbility) -> EnemyAbilityHandlerCast:
	return _cast_handler.setup(ability)

func _resolve_instant(ability: EnemyInstantAbility) -> EnemyAbilityHandlerInstant:
	return _instant_handler.setup(ability)
