class_name CharacterAbilityExecuteEffectSprintHandler extends CharacterAbilityExecuteEffectHandler

var _data: CharacterAbilityEffectSprint

func setup(data: CharacterAbilityEffect) -> void:
	_data = data

func execute(_aiming_result: CharacterAbilityAimingResult) -> void:
	_context.use_sprinting_speed()

func release() -> void:
	_context.use_normal_speed()
	_ability.start_cooldown()

func tick(delta: float) -> void:
	if _ability._data.cost.type == AbilityCost.Type.Tick:
		_ability.use_resources_delta(delta)
