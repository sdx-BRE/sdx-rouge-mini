class_name SkeletonIceMage extends BaseSkeletonEnemy

@export_group("Abilities")
@export var dev_ability: AbilityData

@onready var staff_spawn_point := $Pivot/Rig_Medium/Skeleton3D/BoneAttachment3D/staff2/StaffSpawnPoint

var _ability_system: AbilitySystem

func execute_cast() -> void:
	_ability_system.notify_animation_event()
