class_name SkeletonMinionProcessor extends RefCounted

var _kinematics: EnemyKinematics
var _state_machine: SkeletonMinionStateMachine
var _locomotion_handler: SkeletonMinionLocomotionHandler

func _init(
	kinematics: EnemyKinematics,
	state_machine: SkeletonMinionStateMachine,
	locomotion_handler: SkeletonMinionLocomotionHandler,
) -> void:
	_kinematics = kinematics
	_state_machine = state_machine
	_locomotion_handler = locomotion_handler

func physics_process(delta: float):
	_kinematics.handle_gravity(delta)
	_state_machine.process(delta)
	_locomotion_handler.handle(delta)
	
	_kinematics.move_and_slide()
