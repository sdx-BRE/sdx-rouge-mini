class_name SkeletonBossExecuteStrategy extends AbilityExecuteStrategy

const SPAWN_CONTAINER_NAME := &"BossAbilitiesSpawnContainer"

var _host: Node3D
var _spawn_container: Node3D

func _init(host: Node3D, spawn_container: Node3D) -> void:
	_host = host
	_spawn_container = spawn_container

static func create(host: Node3D) -> SkeletonBossExecuteStrategy:
	var spawn_container := Node3D.new()
	host.add_child(spawn_container)
	
	spawn_container.top_level = true
	spawn_container.name = SPAWN_CONTAINER_NAME
	spawn_container.owner = host.get_tree().current_scene
	
	return SkeletonBossExecuteStrategy.new(host, spawn_container)

func spawn_node(node: Node3D) -> void:
	_spawn_container.add_child(node)

func setup_ability(ability: AbilityEntity, data: AbilityDelivery, context: AbilityExecuteContext) -> void:
	ability.setup_enemy_ability(data, context)

func launch_ability(ability: AbilityEntity, data: AbilityDelivery, context: AbilityExecuteContext) -> void:
	ability.launch_enemy_ability(data, context)
