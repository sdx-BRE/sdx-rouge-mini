class_name NCharacterAbilityExecutionPhased extends NCharacterAbilityExecution

@export var scene: PackedScene
@export var anim: CharacterAbilityPhasedAnim

func update_cast_point(tree: AnimationTree) -> void:
	anim.update_cast_point(tree)

func get_handler() -> NCharacterAbilityHandler.Execution:
	return NCharacterAbilityHandler.Execution.Phased
