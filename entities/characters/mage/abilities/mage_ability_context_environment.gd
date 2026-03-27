class_name MageAbilityContextEnvironment extends RefCounted

var anim: MageAnimator
var wandspawn_node: Node3D
var pivot: Node3D
var camera_node: ThirdPersonCam
var aim_decal: Decal
var viewport: Viewport
var world_3d: World3D
var casting_started: Signal
var casting_end: Signal
var casting_progressed: Signal

var _spawn_container: Node3D

func _init(
	p_spawn_container: Node3D,
	p_wandspawn_node: Node3D,
	p_pivot: Node3D,
	p_camera_node: ThirdPersonCam,
	p_aim_decal: Decal,
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
	aim_decal = p_aim_decal
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
		mage.add_child(spawn_container)
	
	spawn_container.top_level = true
	
	return MageAbilityContextEnvironment.new(
		spawn_container,
		mage.wandspawn_node,
		mage.pivot,
		mage.camera_node,
		mage.aim_decal,
		mage.get_viewport(),
		mage.get_world_3d(),
		started,
		progressed,
		end,
	)

func spawn_node(node: Node3D) -> void:
	_spawn_container.add_child(node)
