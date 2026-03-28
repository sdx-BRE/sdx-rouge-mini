class_name MageMovementMotion extends RefCounted

var dash_power: Vector3
var coyote_timer: float
var jump_buffer_timer: float

func _init(p_dash_power: Vector3, p_coyote_timer: float, p_jump_buffer_timer: float) -> void:
	dash_power = p_dash_power
	coyote_timer = p_coyote_timer
	jump_buffer_timer = p_jump_buffer_timer

static func from_mage(mage: MageCharacter) -> MageMovementMotion:
	return MageMovementMotion.new(Vector3.ZERO, mage.data.coyote_time, 0)
