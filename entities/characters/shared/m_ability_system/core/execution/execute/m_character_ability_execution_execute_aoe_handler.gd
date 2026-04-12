class_name MCharacterAbilityExecutionExecuteAoeHandler extends MCharacterAbilityExecutionExecuteEffectHandler

var _data: MCharacterAbilityEffectAoe

func setup(data: MCharacterAbilityEffect) -> void:
	_data = data

func execute(aiming_result: McharacterAbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_when_aoe(node, _setup_aoe)
	_spawn_ability(node)
	_when_aoe(node, func(aoe: BaseAoe): _launch_aoe(aoe, aiming_result))
	
	_emit_finished()

func _spawn_ability(node: Node3D) -> void:
	_context.spawn_at_wand(node)
	node.global_basis = _context.get_pivot_basis()

func _setup_aoe(node: BaseAoe) -> void:
	node.setup_mcharacter_ability(_data)

func _launch_aoe(node: BaseAoe, aiming_result: McharacterAbilityAimingResult) -> void:
	aiming_result.set_aoe_position(node)

func _when_aoe(node: Node, then: Callable) -> void:
	if node is BaseAoe:
		then.call(node)
