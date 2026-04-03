class_name ChanneledAbilityHandler extends CharacterAbilityHandler

var _ability: CharacterChanneledAbility

func try_activate(state: CharacterAbilitySystem.TriggerState) -> void:
	if _ability == null:
		return
	
	if not _ability.has_resources() or state == CharacterAbilitySystem.TriggerState.Release:
		_ability.end()
		_ability = null

func setup(ability: CharacterAbility) -> CharacterAbilityHandler:
	_ability = ability as CharacterChanneledAbility
	return self

func tick(delta: float) -> void:
	if _ability == null:
		return
	
	if not _ability.has_resources():
		_ability.end()
		_ability = null
		return
	
	var result := _ability.tick(delta)
	if result == CharacterChanneledAbility.TickResult.Consume:
		_ability.use_resources()
