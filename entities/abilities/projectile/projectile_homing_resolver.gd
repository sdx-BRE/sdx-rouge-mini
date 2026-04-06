class_name ProjectileHomingResolver extends RefCounted

static func resolve(
	homing: BaseProjectile.Homing,
	projectile: BaseProjectile,
	target: Node3D,
) -> ProjectileHomingBase:
	if target == null:
		return ProjectileDisabledHoming.new(projectile)
	
	if homing == BaseProjectile.Homing.Predictive \
		and target is CharacterBody3D:
		return ProjectilePredictiveHoming.new(projectile, target)
	
	if homing == BaseProjectile.Homing.Simple:
		return ProjectileSimpleHoming.new(projectile, target)
	
	return ProjectileDisabledHoming.new(projectile)
