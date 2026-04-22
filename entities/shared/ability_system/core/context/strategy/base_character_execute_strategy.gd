class_name BaseCharacterExecuteStrategy extends BaseAbilityExecuteStrategy

func setup_ability(ability: AbilityEntity, data: AbilityDelivery, context: AbilityExecuteContext) -> void:
	ability.setup_character_ability(data, context)

func launch_ability(ability: AbilityEntity, data: AbilityDelivery, context: AbilityExecuteContext) -> void:
	ability.launch_character_ability(data, context)

func stop_ability(ability: AbilityEntity, data: AbilityDelivery, context: AbilityExecuteContext) -> void:
	ability.stop_character_ability(data, context)
