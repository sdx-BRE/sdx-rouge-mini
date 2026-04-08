class_name WaveSpawnBase extends RefCounted

var _spawn_container: Node3D

func _init(
	spawn_container: Node3D,
) -> void:
	_spawn_container = spawn_container

func place_enemy(enemy: Node3D) -> void:
	push_error("[Error][WaveEnemySpawnBase]: spawn_enemy() must be overwritten by child implementations, scene: ", enemy)
