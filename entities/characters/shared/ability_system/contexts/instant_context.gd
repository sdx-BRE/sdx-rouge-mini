class_name InstantContext extends RefCounted

var _pivot: Node3D
var _controller: MageController
var _anim_tree: AnimationTree
var _stats: EntityStats

func _init(
	pivot: Node3D,
	controller: MageController,
	anim_tree: AnimationTree,
	stats: EntityStats,
) -> void:
	_pivot = pivot
	_controller = controller
	_anim_tree = anim_tree
	_stats = stats

func has_resources(cost: AbilityCost) -> bool:
	return _stats.has_mana(cost.mana) and _stats.has_stamina(cost.stamina)

func use_resources(cost: AbilityCost) -> void:
	_stats.use_mana(cost.mana)
	_stats.use_stamina(cost.stamina)

func push_dash_motion(dash_power: float) -> void:
	var forward := -_pivot.global_basis.z
	forward.y = 0.0
	forward = forward.normalized()
	
	_controller.push_dash_motion(forward * dash_power)

func request_oneshot(param: StringName) -> void:
	_anim_tree.set(param + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func is_not_moving() -> bool:
	return _controller.is_not_moving()
