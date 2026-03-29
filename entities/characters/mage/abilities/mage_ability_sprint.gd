class_name MageAbilitySprint extends MageAbilityChanneled

func end() -> void:
	_controller.use_normal_speed()

func tick(_delta: float) -> TickResult:
	_controller.use_sprinting_speed()
	
	return TickResult.Consume
