class_name MageProcessor extends RefCounted

var _controller: MageController
var _anim: MageAnimator
var _abilities: MageAbilities
var _viewport: Viewport

var _movement_blend := 0.0

func _init(
	controller: MageController,
	anim: MageAnimator,
	abilities: MageAbilities,
	viewport: Viewport,
) -> void:
	_controller = controller
	_anim = anim
	_abilities = abilities
	_viewport = viewport

func process(delta: float) -> void: 
	_abilities.preparing(delta)

func physics_process(delta: float) -> void: 
	_controller.handle_gravity(delta)
	_controller.move(delta)
	
	var movement_blend_target = _controller.get_speed_ratio()
	_movement_blend = lerp(_movement_blend, movement_blend_target, delta * 10)
	_anim.blend_loco(_movement_blend)

func handle_unhandled_input(event: InputEvent) -> void:
	if _abilities.handle_input(event):
		_viewport.set_input_as_handled()
		return
	
	_controller.delegate_input_to_camera(event)

func use_skill(index: int) -> void:
	match index:
		0: _abilities.prepare_ability(MageAbilities.Id.Firebolt)
		1: print("Todo: implement skill 1")
		2: _abilities.prepare_ability(MageAbilities.Id.Meteor)
