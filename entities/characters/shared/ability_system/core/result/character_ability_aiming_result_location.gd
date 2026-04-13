class_name CharacterAbilityAimingResultLocation extends CharacterAbilityAimingResult

var position: Vector3

func _init(pos: Vector3) -> void:
	position = pos

func set_aoe_position(aoe: BaseAoe, _context: CharacterAbilityExecuteContext) -> void:
	aoe.global_position = position

func set_projectile_target(projectile: BaseProjectile, _context: CharacterAbilityExecuteContext) -> void:
	var target_node := Node3D.new()
	
	_context.spawn_node(target_node)
	projectile.tree_exited.connect(target_node.queue_free)
	
	target_node.top_level = true
	target_node.global_position = position
	
	projectile._target = target_node
