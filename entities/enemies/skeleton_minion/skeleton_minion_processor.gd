class_name SkeletonMinionProcessor extends RefCounted

var _anim: SkeletonMinionAnimator
var _kinematics: EnemyKinematics
var _state_machine: SkeletonMinionStateMachine
var _locomotion_handler: SkeletonMinionLocomotionHandler

func _init(
	anim: SkeletonMinionAnimator,
	kinematics: EnemyKinematics,
	state_machine: SkeletonMinionStateMachine,
	locomotion_handler: SkeletonMinionLocomotionHandler,
) -> void:
	_anim = anim
	_kinematics = kinematics
	_state_machine = state_machine
	_locomotion_handler = locomotion_handler

func process(delta: float):
	_anim.process(delta)

func physics_process(delta: float):
	_kinematics.handle_gravity(delta)
	_state_machine.process(delta)
	_locomotion_handler.handle(delta)
	
	_kinematics.move_and_slide()
