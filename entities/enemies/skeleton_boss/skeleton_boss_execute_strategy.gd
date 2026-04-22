class_name SkeletonBossExecuteStrategy extends BaseEnemyExecuteStrategy

const SPAWN_CONTAINER_NAME := &"BossAbilitiesSpawnContainer"

var _host: Node3D

func _init(host: Node3D, spawn_container: Node3D) -> void:
	super(spawn_container)
	_host = host

static func create(host: Node3D) -> SkeletonBossExecuteStrategy:
	var spawn_container := _create_spawn_container(host, SPAWN_CONTAINER_NAME)
	
	return SkeletonBossExecuteStrategy.new(host, spawn_container)
