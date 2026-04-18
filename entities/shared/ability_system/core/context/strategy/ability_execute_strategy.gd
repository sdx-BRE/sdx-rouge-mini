class_name AbilityExecuteStrategy extends RefCounted

func spawn_node(_node: Node3D) -> void:
	pass

func spawn_at_weapon(_node: Node3D) -> void:
	pass

func spawn_buff(_node: Node3D) -> void:
	pass

func spawn_weapon_child(_node: Node3D) -> void:
	pass

func get_weapon_spawn_node() -> Node3D:
	return null

func get_pivot_basis() -> Basis:
	return Basis.IDENTITY

func push_dash_motion(_dash_power: float) -> void:
	pass

func buffer_jump() -> void:
	pass

func use_sprinting_speed() -> void:
	pass

func use_normal_speed() -> void:
	pass

func setup_ability(_ability: AbilityEntity, _data: AbilityDelivery, _context: AbilityExecuteContext) -> void:
	pass

func launch_ability(_ability: AbilityEntity, _data: AbilityDelivery, _context: AbilityExecuteContext) -> void:
	pass
