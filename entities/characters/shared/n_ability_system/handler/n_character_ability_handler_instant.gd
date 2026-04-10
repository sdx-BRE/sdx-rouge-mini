class_name NCharacterAbilityHandlerInstant extends NCharacterAbilityHandler

var _ability: NCharacterAbilityInstant

func setup(ability: NCharacterAbility) -> void:
	_ability = NCharacterAbilityInstant.new(ability)

func try_activate(state: NCharacterAbilitySystem.TriggerState) -> void:
	if not _ability.has_resources() or _cooldown_manager.has_character_cooldown(_ability._data):
		return
	
	if _ability.trigger(state) == NCharacterAbilityInstant.Result.Consume:
		_ability.use_resources()
		_cooldown_manager.start_character_cooldown(_ability._data)
