class_name WaveSpawnRandomNode extends WaveSpawnBase

var _random_node_container: Node3D

func _init(
	random_node_container: Node3D,
) -> void:
	_random_node_container = random_node_container

func place_enemy(enemy: Node3D) -> void:
	enemy.global_position = _get_random_position()

func _get_random_position() -> Vector3:
	var child_nodes := _random_node_container.get_children() \
		.filter(func(node: Node) -> bool: return node is Marker3D)
	
	if child_nodes.size() == 0:
		push_warning("[WARN][WaveSpawnRandomNode._get_random_position]: random_node_container must have Marker3D child nodes")
		return Vector3.ZERO
	
	return child_nodes.pick_random().global_position
