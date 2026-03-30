class_name EnemyCollisionsHandler extends PhysicsProcessHandler

var _kinematics: EnemyKinematics

func _init(kinematics: EnemyKinematics) -> void:
	_kinematics = kinematics

func physics_process(_delta: float) -> void:
	_kinematics.move_and_slide()
