class_name AbilityAimingAIHandler extends AbilityAimingHandler

func setup(_data: AbilityTargeting) -> void:
	var handler := _context.get_ai_target_handler()
	_emit_target_aquired(AbilityAimingAIResult.new(handler))
