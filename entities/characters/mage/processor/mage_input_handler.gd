class_name MageInputHandler extends InputHandler

var _ability_system: AbilitySystem
var _kinematics: MageKinematics

func _init(
	ability_system: AbilitySystem,
	kinematics: MageKinematics,
) -> void:
	_ability_system = ability_system
	_kinematics = kinematics

func handle_input(event: InputEvent, viewport: Viewport) -> void:
	if _ability_system.handle_input(event):
		viewport.set_input_as_handled()
		return
	
	_kinematics.delegate_input_to_camera(event)
