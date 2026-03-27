class_name MageMovementMotion extends RefCounted

var dash_power: Vector3

func _init(p_dash_power: Vector3) -> void:
	dash_power = p_dash_power

static func create() -> MageMovementMotion:
	return MageMovementMotion.new(Vector3.ZERO)
