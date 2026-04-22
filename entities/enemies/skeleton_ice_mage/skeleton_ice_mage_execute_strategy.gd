class_name SkeletonIceMageExecuteStrategy extends BaseEnemyExecuteStrategy

const SPAWN_CONTAINER_NAME := &"PhasedAbilitiesSpawnContainer"

var _host: Node3D
var _pivot: Node3D
var _staff_spawn_point: Node3D
var _controller: EnemyController

func _init(
	host: Node3D,
	pivot: Node3D,
	staff_spawn_point: Node3D,
	controller: EnemyController,
	spawn_container: Node3D,
) -> void:
	super(spawn_container)
	_host = host
	_pivot = pivot
	_staff_spawn_point = staff_spawn_point
	_controller = controller

static func create(
	host: Node3D,
	pivot: Node3D,
	staff_spawn_point: Node3D,
	controller: EnemyController,
) -> SkeletonIceMageExecuteStrategy:
	var spawn_container := _create_spawn_container(host, SPAWN_CONTAINER_NAME)
	
	return SkeletonIceMageExecuteStrategy.new(
		host,
		pivot,
		staff_spawn_point,
		controller,
		spawn_container,
	)

func spawn_at_weapon(node: Node3D) -> void:
	spawn_node(node)
	node.global_position = _staff_spawn_point.global_position

func spawn_weapon_child(node: Node3D) -> void:
	_staff_spawn_point.add_child(node)

func get_weapon_spawn_node() -> Node3D:
	return _staff_spawn_point

func get_pivot_basis() -> Basis:
	return _pivot.global_basis
