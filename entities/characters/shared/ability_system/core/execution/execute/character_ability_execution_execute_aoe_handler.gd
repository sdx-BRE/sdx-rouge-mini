class_name CharacterAbilityExecutionExecuteAoeHandler extends CharacterAbilityExecutionExecuteEffectHandler

var _data: CharacterAbilityEffectAoe

func setup(data: CharacterAbilityEffect) -> void:
	_data = data

func execute(aiming_result: CharacterAbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_setup_when_ability(node, _data)
	_spawn_ability(node)
	
	aiming_result.set_aoe_position(node, _context)
	_launch_when_ability(node, _data)
	
	_emit_finished()

func _spawn_ability(node: Node3D) -> void:
	_use_resources()
	_ability.start_cooldown()
	
	_context.spawn_at_wand(node)
	node.global_basis = _context.get_pivot_basis()
