class_name EnemyAbilityHandlerInstant extends EnemyAbilityHandler

var _ability: EnemyInstantAbility

func setup(ability: EnemyBaseAbility) -> EnemyAbilityHandler:
	_ability = ability as EnemyInstantAbility
	return self

func try_activate() -> void:
	pass # Todo: Implement try_activate
