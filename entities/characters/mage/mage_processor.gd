class_name MageProcessor extends RefCounted

var _controller: MageController
var _anim: MageAnimator
var _abilities: MageAbilityHandler
var _resource_generator: MageResourceGenerator
var _viewport: Viewport

var _movement_blend := 0.0

func _init(
	controller: MageController,
	anim: MageAnimator,
	abilities: MageAbilityHandler,
	resource_generator: MageResourceGenerator,
	viewport: Viewport,
) -> void:
	_controller = controller
	_anim = anim
	_abilities = abilities
	_resource_generator = resource_generator
	_viewport = viewport

func process(delta: float) -> void:
	_resource_generator.process(delta)
	_anim.process(delta)
	_abilities.process_abilities(delta)

func physics_process(delta: float) -> void: 
	_controller.handle_gravity(delta)
	_controller.update_velocity(delta)
	
	var movement_blend_target := _controller.get_speed_ratio()
	_movement_blend = lerp(_movement_blend, movement_blend_target, delta * 10)
	_anim.blend_loco(_movement_blend)
	
	_controller.move_and_slide()

func handle_unhandled_input(event: InputEvent) -> void:
	if _abilities.handle_input(event):
		_viewport.set_input_as_handled()
		return
	
	_controller.delegate_input_to_camera(event)

func use_skill(index: int) -> void:
	match index:
		0: _abilities.try_activate_ability(MageAbilityId.Id.Firebolt)
		1: print("Todo: implement skill 1")
		2: _abilities.try_activate_ability(MageAbilityId.Id.Meteor)
