class_name AbilityDeliveryProjectile extends AbilityDelivery

@export var scene: PackedScene

@export_group("Projectile Stats")
@export var damage: AbilityDamage
@export var speed := 15.0
@export var lifetime := 3.0

@export_group("Homing")
@export var homing: BaseProjectile.Homing = BaseProjectile.Homing.Disabled
@export_range(-1, 1) var homing_fov := -0.5
@export var homing_steer_speed := 2.0

func create_handler(
	context: AbilityExecuteContext,
	blackboard: AbilityExecutionBlackboard,
) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliveryProjectileHandler.new(context, blackboard)
