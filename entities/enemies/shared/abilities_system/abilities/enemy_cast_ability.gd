class_name EnemyCastAbility extends EnemyBaseAbility

enum AnimType {
	Oneshot
}

@export var scene: PackedScene
@export var anim_trigger: StringName
@export var anim_type: AnimType = AnimType.Oneshot
