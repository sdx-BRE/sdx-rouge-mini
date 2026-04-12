class_name MCharacterAbilityExecutionExecuteAoeHandler extends MCharacterAbilityExecutionExecuteEffectHandler

var _data: MCharacterAbilityEffectAoe

func setup(data: MCharacterAbilityEffect) -> void:
	_data = data

func execute(aiming_result: McharacterAbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_setup_when_ability(node, _data)
	_spawn_ability(node)
	
	aiming_result.set_aoe_position(node)
	_launch_when_ability(node, _data)
	
	_emit_finished()

func _spawn_ability(node: Node3D) -> void:
	_context.spawn_at_wand(node)
	node.global_basis = _context.get_pivot_basis()
