class_name AbilityHandleInputResult extends RefCounted

var is_handled: bool
var action: StringName

func _init(
	p_is_handled: bool,
	p_action: StringName,
) -> void:
	is_handled = p_is_handled
	action = p_action

static func handled(p_action: StringName) -> AbilityHandleInputResult:
	return AbilityHandleInputResult.new(true, p_action)

static func unhandled() -> AbilityHandleInputResult:
	return AbilityHandleInputResult.new(false, &"")
