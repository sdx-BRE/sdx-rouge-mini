class_name CharacterAbilityAimingAIHandler extends CharacterAbilityAimingHandler

func setup(_data: CharacterAbilityTargeting) -> void:
	var handler := _context.get_ai_target_handler()
	_emit_target_aquired(CharacterAbilityAimingAIResult.new(handler))
