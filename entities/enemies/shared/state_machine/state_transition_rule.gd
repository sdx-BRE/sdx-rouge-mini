class_name StateTransitionRule extends RefCounted

var transition_id: int
var condition: Callable

func _init(id: int, cond: Callable) -> void:
	transition_id = id
	condition = cond
