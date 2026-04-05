class_name EnemyAbilityContextCast extends EnemyAbilityContext

const NODE_NAME_SPAWN_CONTAINER := &"AbilityContextCastSpawnContainer"

var _host: CharacterBody3D
var _anim: EnemyAnimator
var _target_handler: AiTargetHandler
var _cast_spawn_node: Node3D
var _spawn_container: Node3D

func _init(
	stats: EntityStats,
	host: CharacterBody3D,
	anim: EnemyAnimator,
	target_handler: AiTargetHandler,
	cast_spawn_node: Node3D,
	spawn_container: Node3D,
) -> void:
	super(stats)
	_host = host
	_anim = anim
	_target_handler = target_handler
	_cast_spawn_node = cast_spawn_node
	_spawn_container = spawn_container

static func create(
	stats: EntityStats,
	host: CharacterBody3D,
	anim: EnemyAnimator,
	target_handler: AiTargetHandler,
	cast_spawn_node: Node3D,
) -> EnemyAbilityContextCast:
	var spawn_container := Node3D.new()
	
	spawn_container.name = NODE_NAME_SPAWN_CONTAINER
	host.add_child(spawn_container)
	spawn_container.owner = host.get_tree().current_scene
	spawn_container.top_level = true
	spawn_container.global_position = Vector3.ZERO
	
	return EnemyAbilityContextCast.new(
		stats,
		host,
		anim,
		target_handler,
		cast_spawn_node,
		spawn_container,
	)

func get_cast_position() -> Vector3:
	return _cast_spawn_node.global_position

func get_host_basis() -> Basis:
	return _host.global_basis

func spawn_node(node: Node) -> void:
	_spawn_container.add_child(node)

func play_oneshot_anim(oneshot_param) -> void:
	_anim.oneshot_fire(oneshot_param)

func get_target() -> Node3D:
	return _target_handler.get_target()

func get_target_position() -> Vector3:
	return _target_handler.get_target_position()
