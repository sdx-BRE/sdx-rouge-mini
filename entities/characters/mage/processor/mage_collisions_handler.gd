class_name MageCollisionsHandler extends PhysicsProcessHandler

var _kinematics: MageKinematics

func _init(
	kinematics: MageKinematics,
) -> void:
	_kinematics = kinematics

func physics_process(_delta: float) -> void:
	_kinematics.move_and_slide()
