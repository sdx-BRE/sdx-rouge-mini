class_name MageAbilityContextEnvironment extends RefCounted

const NODE_NAME_SPAWN_CONTAINER := "AbilityContextEnvironmentSpawnContainer"

var anim: MageAnimator
var wandspawn_node: Node3D
var pivot: Node3D
var camera_node: ThirdPersonCam
var ground_target_marker: Decal
var viewport: Viewport
var world_3d: World3D
var enemy_target_marker: Sprite2D
var casting_started: Signal
var casting_end: Signal
var casting_progressed: Signal

var _spawn_container: Node3D

func _init(
	p_spawn_container: Node3D,
	p_wandspawn_node: Node3D,
	p_pivot: Node3D,
	p_camera_node: ThirdPersonCam,
	p_ground_target_marker: Decal,
	p_enemy_target_marker: Sprite2D,
	p_viewport: Viewport,
	p_world_3d: World3D,
	p_casting_started: Signal,
	p_casting_progressed: Signal,
	p_casting_end: Signal,
) -> void:
	_spawn_container = p_spawn_container
	wandspawn_node = p_wandspawn_node
	pivot = p_pivot
	camera_node = p_camera_node
	ground_target_marker = p_ground_target_marker
	enemy_target_marker = p_enemy_target_marker
	viewport = p_viewport
	world_3d = p_world_3d
	casting_started = p_casting_started
	casting_progressed = p_casting_progressed
	casting_end = p_casting_end

static func from_mage(
	mage: MageCharacter,
	started: Signal,
	progressed: Signal,
	end: Signal,
) -> MageAbilityContextEnvironment:
	var spawn_container := mage.spawn_container
	if spawn_container == null:
		spawn_container = Node3D.new()
		spawn_container.name = NODE_NAME_SPAWN_CONTAINER
		
		mage.add_child(spawn_container)
		spawn_container.owner = mage.get_tree().current_scene
		
		spawn_container.top_level = true
		spawn_container.global_position = Vector3.ZERO
	
	return MageAbilityContextEnvironment.new(
		spawn_container,
		mage.wandspawn_node,
		mage.pivot,
		mage.camera_node,
		mage.ground_target_marker,
		mage.enemy_target_marker,
		mage.get_viewport(),
		mage.get_world_3d(),
		started,
		progressed,
		end,
	)

func spawn_node(node: Node3D) -> void:
	_spawn_container.add_child(node)
