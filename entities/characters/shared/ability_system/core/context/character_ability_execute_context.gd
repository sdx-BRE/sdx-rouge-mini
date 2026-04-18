class_name CharacterAbilityExecuteContext extends RefCounted

var _strategy: CharacterAbilityExecuteStrategy

func _init(strategy: CharacterAbilityExecuteStrategy) -> void:
	_strategy = strategy

func spawn_node(node: Node3D) -> void:
	_strategy.spawn_node(node)

func spawn_at_weapon(node: Node3D) -> void:
	_strategy.spawn_at_weapon(node)

func spawn_buff(node: Node3D) -> void:
	_strategy.spawn_buff(node)

func spawn_weapon_child(node: Node3D) -> void:
	_strategy.spawn_weapon_child(node)

func get_weapon_spawn_node() -> Node3D:
	return _strategy.get_weapon_spawn_node()

func get_pivot_basis() -> Basis:
	return _strategy.get_pivot_basis()

func push_dash_motion(dash_power: float) -> void:
	_strategy.push_dash_motion(dash_power)

func buffer_jump() -> void:
	_strategy.buffer_jump()

func use_sprinting_speed() -> void:
	_strategy.use_sprinting_speed()

func use_normal_speed() -> void:
	_strategy.use_normal_speed()

func setup_ability(ability: AbilityEntity, data: CharacterAbilityDelivery) -> void:
	_strategy.setup_ability(ability, data, self)

func launch_ability(ability: AbilityEntity, data: CharacterAbilityDelivery) -> void:
	_strategy.launch_ability(ability, data, self)
