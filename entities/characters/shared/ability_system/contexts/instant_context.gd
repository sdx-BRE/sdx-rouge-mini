class_name InstantContext extends RefCounted

var _pivot: Node3D
var _controller: MageController
var _anim_tree: AnimationTree

func _init(
	pivot: Node3D,
	controller: MageController,
	anim_tree: AnimationTree,
) -> void:
	_pivot = pivot
	_controller = controller
	_anim_tree = anim_tree

func push_dash_motion(dash_power: float) -> void:
	var forward := -_pivot.global_basis.z
	forward.y = 0.0
	forward = forward.normalized()
	
	_controller.push_dash_motion(forward * dash_power)

func buffer_jump() -> void:
	_controller.buffer_jump()

func request_oneshot(param: StringName) -> void:
	_anim_tree.set(param + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func is_not_moving() -> bool:
	return _controller.is_not_moving()
