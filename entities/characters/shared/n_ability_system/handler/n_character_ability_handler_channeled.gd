class_name NCharacterAbilityHandlerChanneled extends NCharacterAbilityHandler

var _ability: NCharacterAbilityChanneled

func setup(ability: NCharacterAbility) -> void:
	_ability = NCharacterAbilityChanneled.new(ability)

func try_activate(state: NCharacterAbilitySystem.TriggerState) -> void:
	if _ability == null or _cooldown_manager.has_ncharacter_cooldown(_ability.base._data):
		return
	
	if not _ability.base.has_resources() or state == CharacterAbilitySystem.TriggerState.Release:
		_ability.end()
		_ability = null

func tick(delta: float) -> void:
	if _ability == null:
		return
	
	if not _ability.base.has_resources():
		_ability.end()
		_cooldown_manager.start_ncharacter_cooldown(_ability.base._data)
		_ability = null
		return
	
	var result := _ability.tick(delta)
	if result == NCharacterAbilityChanneled.TickResult.Consume:
		_ability.base.use_resources()
