extends ContinuousAbility

@export var rotation_speed: float = 2.0
var _parent: Node3D

func setup_character_ability(data: CharacterAbilityDelivery, context: CharacterAbilityExecuteContext) -> void:
	super(data, context)
	_parent = context.get_weapon_spawn_node()
	top_level = true

func launch_character_ability(data: CharacterAbilityDelivery, context: CharacterAbilityExecuteContext) -> void:
	super(data, context)
	_apply_sway_logic(0.01)
	
	hitbox.scale = Vector3(0.1, 0.1, 0.1)
	var tween := create_tween()
	
	tween.tween_property(hitbox, "scale", Vector3(1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE)

func _process(delta: float) -> void:
	if _parent == null:
		return
	_apply_sway_logic(delta)

func _apply_sway_logic(delta: float) -> void:
	global_position = _parent.global_position
	
	var target_quat := _parent.global_transform.basis.get_rotation_quaternion()
	var current_quat := global_transform.basis.get_rotation_quaternion()
	
	var smooth_quat := current_quat.slerp(target_quat, rotation_speed * delta)
	global_transform.basis = Basis(smooth_quat)
