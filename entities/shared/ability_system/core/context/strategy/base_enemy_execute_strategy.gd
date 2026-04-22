class_name BaseEnemyExecuteStrategy extends BaseAbilityExecuteStrategy

func setup_ability(ability: AbilityEntity, data: AbilityDelivery, context: AbilityExecuteContext) -> void:
	ability.setup_enemy_ability(data, context)

func launch_ability(ability: AbilityEntity, data: AbilityDelivery, context: AbilityExecuteContext) -> void:
	ability.launch_enemy_ability(data, context)

func stop_ability(ability: AbilityEntity, data: AbilityDelivery, context: AbilityExecuteContext) -> void:
	ability.stop_enemy_ability(data, context)
