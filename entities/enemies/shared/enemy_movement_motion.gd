class_name EnemyMovementMotion extends RefCounted

var speed: float
var is_movement_enabled: bool

var rotate_to_target: Vector3
var is_target_rotation_enabled: bool

func _init(
	p_speed: float, 
	p_is_movement_enabled: float,
	p_rotate_to_target: Vector3,
	p_is_target_rotation_enabled: bool,
) -> void:
	speed = p_speed
	is_movement_enabled = p_is_movement_enabled
	rotate_to_target = p_rotate_to_target
	is_target_rotation_enabled = p_is_target_rotation_enabled

static func create() -> EnemyMovementMotion:
	return EnemyMovementMotion.new(
		0.0,
		false,
		Vector3.ZERO,
		false,
	)
