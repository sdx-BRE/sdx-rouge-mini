class_name InstantAbilityHandler extends CharacterAbilityHandler

var _ability: CharacterInstantAbility

func try_activate(state: CharacterAbilitySystem.TriggerState) -> void:
	if not _ability.has_resources() or _cooldown_manager.has_character_cooldown(_ability._data):
		return
	
	if _ability.trigger(state) == CharacterInstantAbility.Result.Consume:
		_ability.use_resources()
		_cooldown_manager.start_character_cooldown(_ability._data)

func setup(ability: CharacterAbility) -> CharacterAbilityHandler:
	_ability = ability as CharacterInstantAbility
	return self
