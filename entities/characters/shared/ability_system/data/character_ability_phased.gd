class_name CharacterAbilityPhased extends CharacterAbilityData

@export var scene: PackedScene
@export var anim: CharacterAbilityPhasedAnim

func update_cast_point(tree: AnimationTree) -> void:
	anim.update_cast_point(tree)
