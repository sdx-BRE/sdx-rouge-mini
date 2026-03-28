class_name MageProcessor extends RefCounted

var _kinematics: MageKinematics
var _motor: MageMotor
var _sensors: MageSensors
var _anim: MageAnimator
var _abilities: MageAbilityHandler
var _resource_generator: MageResourceGenerator
var _airboune_observer: ObserverAirbourne
var _viewport: Viewport

var _movement_blend := 0.0

func _init(
	kinematics: MageKinematics,
	motor: MageMotor,
	sensors: MageSensors,
	anim: MageAnimator,
	abilities: MageAbilityHandler,
	resource_generator: MageResourceGenerator,
	airboune_observer: ObserverAirbourne,
	viewport: Viewport,
) -> void:
	_kinematics = kinematics
	_motor = motor
	_sensors = sensors
	_anim = anim
	_abilities = abilities
	_resource_generator = resource_generator
	_airboune_observer = airboune_observer
	_viewport = viewport

func process(delta: float) -> void:
	_resource_generator.process(delta)
	_anim.process(delta)
	_abilities.process_abilities(delta)
	_airboune_observer.process()

func physics_process(delta: float) -> void:
	_sensors.physics_update(delta)
	_motor.apply_impulses(delta) 
	_kinematics.handle_gravity(delta)
	_kinematics.update_velocity(delta)
	
	var movement_blend_target := _kinematics.get_speed_ratio()
	_movement_blend = lerp(_movement_blend, movement_blend_target, delta * 10)
	_anim.blend_loco(_movement_blend)
	
	_kinematics.move_and_slide()

func handle_unhandled_input(event: InputEvent) -> void:
	if _abilities.handle_input(event):
		_viewport.set_input_as_handled()
		return
	
	_kinematics.delegate_input_to_camera(event)
