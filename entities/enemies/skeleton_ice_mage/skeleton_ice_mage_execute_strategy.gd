class_name SkeletonIceMageExecuteStrategy extends CharacterAbilityExecuteStrategy

const SPAWN_CONTAINER_NAME := &"PhasedAbilitiesSpawnContainer"

var _host: Node3D
var _pivot: Node3D
var _staff_spawn_point: Node3D
var _controller: EnemyController
var _spawn_container: Node3D

func _init(
	host: Node3D,
	pivot: Node3D,
	staff_spawn_point: Node3D,
	controller: EnemyController,
	spawn_container: Node3D,
) -> void:
	_host = host
	_pivot = pivot
	_staff_spawn_point = staff_spawn_point
	_controller = controller
	_spawn_container = spawn_container

static func create(
	host: Node3D,
	pivot: Node3D,
	staff_spawn_point: Node3D,
	controller: EnemyController,
) -> SkeletonIceMageExecuteStrategy:
	var spawn_container := Node3D.new()
	host.add_child(spawn_container)
	
	spawn_container.top_level = true
	spawn_container.name = SPAWN_CONTAINER_NAME
	spawn_container.owner = host.get_tree().current_scene
	
	return SkeletonIceMageExecuteStrategy.new(
		host,
		pivot,
		staff_spawn_point,
		controller,
		spawn_container,
	)

func spawn_node(node: Node3D) -> void:
	_spawn_container.add_child(node)

func spawn_at_weapon(node: Node3D) -> void:
	spawn_node(node)
	node.global_position = _staff_spawn_point.global_position

func spawn_weapon_child(node: Node3D) -> void:
	_staff_spawn_point.add_child(node)

func get_weapon_spawn_node() -> Node3D:
	return _staff_spawn_point

func get_pivot_basis() -> Basis:
	return _pivot.global_basis
