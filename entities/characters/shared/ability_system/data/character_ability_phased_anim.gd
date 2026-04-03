class_name CharacterAbilityPhasedAnim extends Resource

@export var trigger: StringName
@export var name: StringName
@export var call_method_track_name: StringName = &"execute_cast"

var cast_point: float = 0.1

func update_cast_point(tree: AnimationTree) -> void:
	var player := tree.get_node(tree.anim_player) as AnimationPlayer
	var c_point = AnimationUtil.try_get_call_method_track_time(player, name, call_method_track_name)
	
	if c_point != null:
		cast_point = c_point
