class_name WaveSpawnCircle extends WaveSpawnBase

var _spawn_point: Node3D
var _spawn_radius: float

func _init(
	spawn_point: Node3D, 
	spawn_radius: float,
) -> void:
	_spawn_point = spawn_point
	_spawn_radius = spawn_radius

func spawn_enemy(enemy: Node3D) -> void:
	var angle := randf() * TAU
	var r := sqrt(randf()) * _spawn_radius
	var random_offset := Vector3(cos(angle) * r, 0, sin(angle) * r)
	
	enemy.global_position = _spawn_point.global_position + random_offset
