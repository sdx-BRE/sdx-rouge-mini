class_name WaveSpawnAtPositions extends WaveSpawnBase

var _positions: Array[Marker3D]
var _position_idx := 0

func _init(
	positions: Array[Marker3D],
) -> void:
	if positions.size() == 0:
		push_error(DbgHelper.err("WaveSpawnAtPositions._init", "positions arg must have at least one element!"))
	
	_positions = positions

func spawn_enemy(enemy: Node3D) -> void:
	enemy.global_position = _positions[_position_idx].global_position
	_next_idx()

func _next_idx() -> void:
	var next_idx := _position_idx + 1
	if next_idx >= _positions.size() - 1:
		_position_idx = 0
	else:
		_position_idx = next_idx
