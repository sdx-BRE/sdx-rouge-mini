class_name EnemyMovementMotion extends RefCounted

var speed: float
var is_movement_enabled: bool

func _init(p_speed: float, p_is_movement_enabled: float) -> void:
	speed = p_speed
	is_movement_enabled = p_is_movement_enabled

static func create() -> EnemyMovementMotion:
	return EnemyMovementMotion.new(0.0, false)
