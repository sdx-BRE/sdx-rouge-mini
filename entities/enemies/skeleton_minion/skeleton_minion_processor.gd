class_name SkeletonMinionProcessor extends RefCounted

var _anim: SkeletonMinionAnimator
var _controller: SkeletonMinionController
var _state_machine: SkeletonMinionStateMachine
var _locomotion_handler: SkeletonMinionLocomotionHandler

func _init(
	anim: SkeletonMinionAnimator,
	controller: SkeletonMinionController,
	state_machine: SkeletonMinionStateMachine,
	locomotion_handler: SkeletonMinionLocomotionHandler,
) -> void:
	_anim = anim
	_controller = controller
	_state_machine = state_machine
	_locomotion_handler = locomotion_handler

func process(delta: float):
	_anim.process(delta)

func physics_process(delta: float):
	_controller.handle_gravity(delta)
	_state_machine.process(delta)
	_locomotion_handler.handle(delta)
	
	_controller.move_and_slide()

func target_entered(target: Node3D) -> void:
	_state_machine.target_entered(target)

func target_exited(target: Node3D) -> void:
	_state_machine.target_exited(target)
