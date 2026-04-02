class_name GroundTargetAbility extends Resource

@export var scene: PackedScene
@export var anim: AbilityAnim
@export var cost: AbilityCost
@export var damage: float = 1.0
@export var cast_range: float = 20.0

func update_cast_point(tree: AnimationTree) -> void:
	anim.update_cast_point(tree)
