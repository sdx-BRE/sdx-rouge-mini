class_name MCharacterAbilityExecutionExecuteProjectileHandler extends MCharacterAbilityExecutionExecuteEffectHandler

var _data: MCharacterAbilityEffectProjectile

func setup(data: MCharacterAbilityEffect) -> void:
	_data = data

func execute(aiming_result: McharacterAbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_setup_when_ability(node, _data)
	aiming_result.set_projectile_target(node)
	
	_use_resources()
	_spawn_ability(node)
	_launch_when_ability(node, _data)
	
	_emit_finished()

func _spawn_ability(node: Node3D) -> void:
	_context.spawn_at_wand(node)
	node.global_basis = _context.get_pivot_basis()
