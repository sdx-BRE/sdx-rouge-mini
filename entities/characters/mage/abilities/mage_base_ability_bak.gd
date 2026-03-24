class_name MageBaseAbilityBak extends RefCounted

var _controller: MageController
var _context: MageAbilityContext
var _cost: MageAbilityCost

func _init(controller: MageController, context: MageAbilityContext, cost: MageAbilityCost) -> void:
	_controller = controller
	_context = context
	_cost = cost

func start() -> void: 
	push_error("[Error][MageAbilityBase]: start() must be overwritten by child implementations")

func update(_delta: float) -> void: 
	push_error("[Error][MageAbilityBase]: update() must be overwritten by child implementations")

func handle_input(_event: InputEvent) -> bool:
	push_error("[Error][MageAbilityBase]: handle_input() must be overwritten by child implementations")
	return false

func execute() -> void: 
	push_error("[Error][MageAbilityBase]: execute() must be overwritten by child implementations")

func cancel() -> void: 
	push_error("[Error][MageAbilityBase]: cancel() must be overwritten by child implementations")

func tick_cast(_delta: float) -> void: 
	push_error("[Error][MageAbilityBase]: tick_cast() must be overwritten by child implementations")

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

class SpellAbility extends MageBaseAbility:
	var _anim: MageSpellAnimation
	
	func _init(
		controller: MageController,
		context: MageAbilityContext,
		cost: MageAbilityCost,
		anim: MageSpellAnimation
	):
		super(controller, context, cost)
		_anim = anim
	
	func tick_cast(_delta: float) -> void:
		_context.notify_casting_progressed(_anim)

class InstantAbility extends MageBaseAbility:
	func preparing(_delta: float) -> void: pass
	func cancel() -> void: pass
	func handle_input(_event: InputEvent) -> bool: return false

class InstantSpell extends MageBaseAbility.SpellAbility:
	func preparing(_delta: float) -> void: pass
	func cancel() -> void: pass
	func handle_input(_event: InputEvent) -> bool: return false
