class_name MageMovementMotion extends RefCounted

var target_speed: float
var coyote_timer: float
var dash_power: Vector3 = Vector3.ZERO
var jump_buffer_timer: float = 0.0

func _init(
	p_target_speed: float,
	p_coyote_timer: float,
) -> void:
	target_speed = p_target_speed
	coyote_timer = p_coyote_timer

static func from_mage(mage: MageCharacter) -> MageMovementMotion:
	return MageMovementMotion.new(
		mage.data.speed_normal,
		mage.data.coyote_time,
	)
