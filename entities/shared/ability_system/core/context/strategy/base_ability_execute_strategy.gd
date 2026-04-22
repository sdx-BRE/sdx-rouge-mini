class_name BaseAbilityExecuteStrategy extends AbilityExecuteStrategy

var _spawn_container: Node3D

func _init(spawn_container: Node3D) -> void:
	_spawn_container = spawn_container

func spawn_node(node: Node3D) -> void:
	_spawn_container.add_child(node)

static func _create_spawn_container(host: Node3D, name: StringName) -> Node3D:
	var spawn_container := Node3D.new()
	host.add_child(spawn_container)
	
	spawn_container.top_level = true
	spawn_container.name = name
	spawn_container.owner = host.get_tree().current_scene
	
	return spawn_container
