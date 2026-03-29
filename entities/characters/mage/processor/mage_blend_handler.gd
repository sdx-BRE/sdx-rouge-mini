class_name MageBlendHandler extends PhysicsProcessHandler

var _kinematics: MageKinematics
var _anim: MageAnimator

var _movement_blend := 0.0

func _init(
	kinematics: MageKinematics,
	anim: MageAnimator,
) -> void:
	_kinematics = kinematics
	_anim = anim

func physics_process(delta: float) -> void:
	var movement_blend_target := _kinematics.get_speed_ratio()
	_movement_blend = lerp(_movement_blend, movement_blend_target, delta * 10)
	_anim.blend_loco(_movement_blend)
