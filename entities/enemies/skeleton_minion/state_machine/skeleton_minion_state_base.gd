class_name SkeletonMinionStateBase extends RefCounted

var _controller: SkeletonMinionController
var _target_handler: SkeletonMinionStateMachineTargetHandler
var _anim: SkeletonMinionAnimator
var _data: SkeletonMinionStateData
var _config: SkeletonMinionStateConfig

func _init(
	controller: SkeletonMinionController,
	target_handler: SkeletonMinionStateMachineTargetHandler,
	anim: SkeletonMinionAnimator,
	data: SkeletonMinionStateData,
	config: SkeletonMinionStateConfig,
) -> void:
	_controller = controller
	_target_handler = target_handler
	_anim = anim
	_data = data
	_config = config

func process(delta: float) -> SkeletonMinionStateMachine.ChangeId:
	push_error("[Error][SkeletonMinionStateBase]: process() must be overwritten by child implementations")
	return SkeletonMinionStateMachine.ChangeId

func enter() -> void: pass
