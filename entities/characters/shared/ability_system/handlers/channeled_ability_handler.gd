class_name ChanneledAbilityHandler extends CharacterAbilityHandler

var _ability: CharacterChanneledAbility

func try_activate(state: CharacterAbilitySystem.TriggerState) -> void:
	if state == CharacterAbilitySystem.TriggerState.Release:
		_ability.end()
		_ability = null

func setup(ability: CharacterAbility) -> CharacterAbilityHandler:
	_ability = ability as CharacterChanneledAbility
	return self

func tick(delta: float) -> void:
	if _ability != null:
		var result := _ability.tick(delta)
		if result == MageAbilityChanneled.TickResult.Consume:
			_ability.use_resources()
