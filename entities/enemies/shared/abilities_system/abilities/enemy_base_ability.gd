class_name EnemyBaseAbility extends Resource

var id: int

@export var disabled := false
@export var cost: EnemyAbilityCost
@export var cooldown: float = 0.0
@export_flags_3d_physics var collision_mask: int
