class_name EnemyVelocityHandler extends PhysicsProcessHandler

var _kinematics: EnemyKinematics

func _init(kinematics: EnemyKinematics) -> void:
	_kinematics = kinematics

func physics_process(delta: float) -> void:
	_kinematics.handle_gravity(delta)
	_kinematics.update_velocity(delta)
