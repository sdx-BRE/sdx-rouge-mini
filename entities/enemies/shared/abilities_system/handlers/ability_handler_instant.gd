class_name AbilityHandlerInstant extends AbilityHandler

var _ability: InstantAbility

func setup(ability: BaseAbility) -> AbilityHandler:
	_ability = ability as InstantAbility
	return self

func try_activate() -> void:
	pass # Todo: Implement try_activate
