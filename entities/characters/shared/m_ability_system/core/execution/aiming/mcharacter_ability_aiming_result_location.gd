class_name McharacterAbilityAimingResultLocation extends McharacterAbilityAimingResult

var position: Vector3

func _init(pos: Vector3) -> void:
	position = pos

func set_aoe_position(aoe: BaseAoe) -> void:
	aoe.global_position = position

func set_projectile_target(projectile: BaseProjectile) -> void:
	var target_node := Node3D.new()
	
	projectile.add_child(target_node)
	projectile.tree_exited.connect(target_node.queue_free)
	
	target_node.top_level = true
	target_node.global_position = position
	
	projectile._target = target_node
