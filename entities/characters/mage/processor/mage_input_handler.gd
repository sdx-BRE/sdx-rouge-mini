class_name MageInputHandler extends InputHandler

var _abilities: MageAbilityHandler
var _kinematics: MageKinematics

func _init(
	abilities: MageAbilityHandler,
	kinematics: MageKinematics,
) -> void:
	_abilities = abilities
	_kinematics = kinematics

func handle_input(event: InputEvent, viewport: Viewport) -> void:
	if _abilities.handle_input(event):
		viewport.set_input_as_handled()
		return
	
	_kinematics.delegate_input_to_camera(event)
