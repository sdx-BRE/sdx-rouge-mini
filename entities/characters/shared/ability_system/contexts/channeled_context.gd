class_name ChanneledContext extends CharacterAbilityContext

var _controller: MageController

func _init(
	controller: MageController,
) -> void:
	_controller = controller

func use_sprinting_speed() -> void:
	_controller.use_sprinting_speed()

func use_normal_speed() -> void:
	_controller.use_normal_speed()
