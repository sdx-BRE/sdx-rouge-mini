class_name MageVelocityHandler extends PhysicsProcessHandler

var _kinematics: MageKinematics
var _motor: MageMotor

func _init(
	kinematics: MageKinematics,
	motor: MageMotor,
) -> void:
	_kinematics = kinematics
	_motor = motor

func physics_process(delta: float) -> void:
	_motor.apply_impulses(delta) 
	_kinematics.handle_gravity(delta)
	_kinematics.update_velocity(delta)
