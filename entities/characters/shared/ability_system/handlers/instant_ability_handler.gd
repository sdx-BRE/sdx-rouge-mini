class_name InstantAbilityHandler extends CharacterAbilityHandler

var _ability: CharacterInstantAbility

func try_activate(state: CharacterAbilitySystem.TriggerState) -> void:
	if _ability.trigger(state) == CharacterInstantAbility.Result.Trigger:
		_ability.use_resources()

func setup(ability: CharacterAbility) -> CharacterAbilityHandler:
	_ability = ability as CharacterInstantAbility
	return self
