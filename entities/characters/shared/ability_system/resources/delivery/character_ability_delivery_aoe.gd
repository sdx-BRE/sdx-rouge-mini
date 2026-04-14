class_name CharacterAbilityDeliveryAoe extends CharacterAbilityDelivery

@export var scene: PackedScene
@export var damage: float = 0.0
@export var delay: float = 0.75
@export var radius: float = 2.0

func create_handler(
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteDeliveryHandler:
	return CharacterAbilityExecuteDeliveryAoeHandler.new(context)
