class_name SkeletonMinion extends BaseSkeletonEnemy

@export var punch_damage := 5.0
@onready var punch_hitbox: Area3D = $Pivot/Rig_Medium/Skeleton3D/BoneHandslotR/Hitbox

func _on_punch(body: Node3D) -> void:
	if body.has_method("take_dmg"):
		body.take_dmg(punch_damage)
