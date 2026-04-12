class_name MCharacterAbilityExecutionExecuteProjectileHandler extends MCharacterAbilityExecutionExecuteEffectHandler

var _data: MCharacterAbilityEffectProjectile

func setup(data: MCharacterAbilityEffect) -> void:
	_data = data

func execute(aiming_result: McharacterAbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	if node is BaseProjectile:
		_setup_projectile(node, aiming_result)
	_spawn_ability(node)
	_emit_finished()

func _spawn_ability(node: Node3D) -> void:
	_context.spawn_at_wand(node)
	node.global_basis = _context.get_pivot_basis()

func _setup_projectile(node: BaseProjectile, aiming_result: McharacterAbilityAimingResult):
	node.setup_mcharacter_ability(_data)
	aiming_result.set_projectile_target(node)
