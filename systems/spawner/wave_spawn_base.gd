class_name WaveSpawnBase extends RefCounted

func place_enemy(enemy: Node3D) -> void:
	push_error("[Error][WaveEnemySpawnBase]: spawn_enemy() must be overwritten by child implementations, scene: ", enemy)
