class_name CharacterAbilityAimingAIHandler extends CharacterAbilityAimingHandler

func setup(_data: CharacterAbilityTargeting) -> void:
	_emit_target_aquired(CharacterAbilityAimingResult.new())
