class_name CharacterAbilityRecoverContext extends RefCounted

var _anim_tree: AnimationTree

func _init(anim_tree: AnimationTree) -> void:
	_anim_tree = anim_tree

func fadeout_oneshot(param: StringName) -> void:
	_anim_tree.set(param + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
