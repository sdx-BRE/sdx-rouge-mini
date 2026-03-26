class_name SkeletonMinionStateMachineStateHandler extends RefCounted

var _handler: SkeletonMinionStateMachineStateHandlerBase

func _init(handler: SkeletonMinionStateMachineStateHandlerBase) -> void:
	_handler = handler

func handle(delta: float) -> void:
	_handler.handle(delta)
