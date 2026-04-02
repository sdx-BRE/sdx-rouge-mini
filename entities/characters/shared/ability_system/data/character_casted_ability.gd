class_name CharacterCastedAbility extends Resource

@export var scene: PackedScene
@export var anim: AbilityAnim
@export var cost: AbilityCost
@export var damage: float = 1.0

func update_cast_point(tree: AnimationTree) -> void:
	anim.update_cast_point(tree)
