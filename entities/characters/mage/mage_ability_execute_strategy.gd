class_name MageAbilityExecuteStrategy extends CharacterAbilityExecuteStrategy

const SPAWN_CONTAINER_NAME := &"PhasedAbilitiesSpawnContainer"

var _host: CharacterBody3D
var _pivot: Node3D
var _buff_anchor: Node3D
var _weaponspawn_node: Node3D
var _controller: MageController
var _spawn_container: Node3D

func _init(
	host: CharacterBody3D,
	pivot: Node3D,
	buff_anchor: Node3D,
	weaponspawn_node: Node3D,
	controller: MageController,
	spawn_container: Node3D,
) -> void:
	_host = host
	_pivot = pivot
	_buff_anchor = buff_anchor
	_weaponspawn_node = weaponspawn_node
	_controller = controller
	_spawn_container = spawn_container

static func create(
	host: CharacterBody3D,
	pivot: Node3D,
	buff_anchor: Node3D,
	weaponspawn_node: Node3D,
	controller: MageController,
) -> MageAbilityExecuteStrategy:
	var spawn_container := Node3D.new()
	host.add_child(spawn_container)
	
	spawn_container.top_level = true
	spawn_container.name = SPAWN_CONTAINER_NAME
	spawn_container.owner = host.get_tree().current_scene
	
	return MageAbilityExecuteStrategy.new(
		host,
		pivot,
		buff_anchor,
		weaponspawn_node,
		controller,
		spawn_container,
	)

func spawn_node(node: Node3D) -> void:
	_spawn_container.add_child(node)

func spawn_at_weapon(node: Node3D) -> void:
	spawn_node(node)
	node.global_position = _weaponspawn_node.global_position

func spawn_buff(node: Node3D) -> void:
	_buff_anchor.add_child(node)

func spawn_weapon_child(node: Node3D) -> void:
	_weaponspawn_node.add_child(node)

func get_weapon_spawn_node() -> Node3D:
	return _weaponspawn_node

func get_pivot_basis() -> Basis:
	return _pivot.global_basis

func push_dash_motion(dash_power: float) -> void:
	var forward := -_pivot.global_basis.z
	forward.y = 0.0
	forward = forward.normalized()
	
	_controller.push_dash_motion(forward * dash_power)

func buffer_jump() -> void:
	_controller.buffer_jump()

func use_sprinting_speed() -> void:
	_controller.use_sprinting_speed()

func use_normal_speed() -> void:
	_controller.use_normal_speed()

func setup_ability(ability: AbilityEntity, data: CharacterAbilityDelivery, context: CharacterAbilityExecuteContext) -> void:
	ability.setup_character_ability(data, context)

func launch_ability(ability: AbilityEntity, data: CharacterAbilityDelivery, context: CharacterAbilityExecuteContext) -> void:
	ability.launch_character_ability(data, context)
