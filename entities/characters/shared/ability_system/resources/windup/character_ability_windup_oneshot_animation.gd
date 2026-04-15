class_name CharacterAbilityWindupOneshotAnimation extends CharacterAbilityWindup

@export var anim_trigger: StringName = &""
@export var anim_name: StringName = &""
@export var call_method_track_name: StringName = &"execute_cast"

var cast_point: float = 0.1

func update_cast_point(tree: AnimationTree) -> void:
	var player := tree.get_node(tree.anim_player) as AnimationPlayer
	var c_point = AnimationUtil.try_get_call_method_track_time(player, anim_name, call_method_track_name)
	
	if c_point != null:
		cast_point = c_point

func create_setup_handler(context: CharacterAbilitySetupContext) -> CharacterAbilitySetupWindupHandler:
	return CharacterAbilitySetupOneshotAnimationHandler.new(context)
