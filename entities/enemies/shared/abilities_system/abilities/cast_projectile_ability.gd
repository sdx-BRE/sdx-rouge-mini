class_name CastProjectileAbility extends CastAbility

@export_group("Projectile Stats")
@export var damage := 10.0
@export var speed := 15.0
@export var lifetime := 3.0

@export_group("Homing")
@export var enable_homing := false
@export_range(-1, 1) var homing_fov := -0.5
@export var homing_steer_speed := 2.0
