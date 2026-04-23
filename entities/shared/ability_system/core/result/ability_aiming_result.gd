class_name AbilityAimingResult extends RefCounted

## Called BEFORE the node is added to the scene tree.
func set_projectile_target(_projectile: BaseProjectile, _context: AbilityExecuteContext) -> void:
	pass

## Called AFTER the node is added to the scene tree and positioned at the weapon.
func launch_projectile(_projectile: BaseProjectile, _context: AbilityExecuteContext) -> void:
	pass

## Called BEFORE the node is added to the scene tree.
func set_aoe_position(_aoe: BaseAoe, _context: AbilityExecuteContext) -> void:
	pass

## Called AFTER the node is added to the scene tree and positioned at the weapon.
func launch_aoe(_aoe: BaseAoe, _context: AbilityExecuteContext) -> void:
	pass
