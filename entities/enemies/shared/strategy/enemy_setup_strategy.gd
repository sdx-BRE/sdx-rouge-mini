class_name EnemySetupStrategy extends AbilitySetupStrategy

var _anim_tree: AnimationTree

func _init(anim_tree: AnimationTree) -> void:
	_anim_tree = anim_tree

func oneshot(param: StringName) -> void:
	_anim_tree.set(param + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func cancel_oneshot(param: StringName, fadeout: bool = true) -> void:
	var req := AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT if fadeout \
		else AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	_anim_tree.set(param + "/request", req)
