class_name WaveSpawnRandomNode extends WaveSpawnBase

var _random_node_container: Node3D

var _positions: Array[Vector3]

func _init(
	random_node_container: Node3D,
) -> void:
	_random_node_container = random_node_container

func place_enemy(enemy: Node3D) -> void:
	enemy.global_position = _pick_random_position()

func _pick_random_position() -> Vector3:
	if _positions.size() == 0:
		_populate_positions()
	
	var rng_idx := randi() % _positions.size()
	var pos := _positions[rng_idx]
	
	_positions.remove_at(rng_idx)
	return pos

func _populate_positions():
	_positions = []
	for node in _random_node_container.get_children() \
		.filter(func(node: Node) -> bool: return node is Marker3D):
			_positions.append(node.global_position)
