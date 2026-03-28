class_name MageAbilityBase extends RefCounted

var _controller: MageController
var _context: MageAbilityContext
var _cost: MageAbilityCost

enum TriggerState {
	PRESS,
	RELEASE,
}

func _init(controller: MageController, context: MageAbilityContext, cost: MageAbilityCost) -> void:
	_controller = controller
	_context = context
	_cost = cost

func has_resources() -> bool:
	return _context.has_resources(_cost)

func use_resources() -> void:
	_context.use_resources(_cost)

func cancel() -> void: 
	push_error("[Error][MageAbilityBase]: cancel() must be overwritten by child implementations")

func _init_at_wand_spawnpoint(scene: PackedScene) -> Node3D:
	var node := _init_scene(scene)
	node.global_position = _context.get_cast_origin()
	
	node.global_basis = _context.get_host_transform_basis()
	node.global_basis = node.global_basis.rotated(Vector3.UP, PI)
	node.global_basis.z.y = 0
	node.global_basis = node.global_basis.orthonormalized()
	
	return node

func _init_scene(scene: PackedScene) -> Node3D:
	var node := scene.instantiate()
	_context.spawn_node(node)
	return node
