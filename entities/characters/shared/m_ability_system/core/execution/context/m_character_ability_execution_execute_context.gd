class_name MCharacterAbilityExecutionExecuteContext extends RefCounted

const SPAWN_CONTAINER_NAME := &"PhasedAbilitiesSpawnContainer"

var _host: CharacterBody3D
var _pivot: Node3D
var _buff_anchor: Node3D
var _wandspawn_node: Node3D
var _spawn_container: Node3D

func _init(
	host: CharacterBody3D,
	pivot: Node3D,
	buff_anchor: Node3D,
	wandspawn_node: Node3D,
	spawn_container: Node3D,
) -> void:
	_host = host
	_pivot = pivot
	_buff_anchor = buff_anchor
	_wandspawn_node = wandspawn_node
	_spawn_container = spawn_container

static func create(
	host: CharacterBody3D,
	pivot: Node3D,
	buff_anchor: Node3D,
	wandspawn_node: Node3D,
) -> MCharacterAbilityExecutionExecuteContext:
	var spawn_container := Node3D.new()
	host.add_child(spawn_container)
	
	spawn_container.top_level = true
	spawn_container.name = SPAWN_CONTAINER_NAME
	spawn_container.owner = host.get_tree().current_scene
	
	return MCharacterAbilityExecutionExecuteContext.new(
		host,
		pivot,
		buff_anchor,
		wandspawn_node,
		spawn_container,
	)

func spawn_node(node: Node3D) -> void:
	_spawn_container.add_child(node)

func spawn_at_wand(node: Node3D) -> void:
	spawn_node(node)
	node.global_position = _wandspawn_node.global_position

func spawn_buff(node: Node3D) -> void:
	_buff_anchor.add_child(node)

func get_wandspawn_position() -> Vector3:
	return _wandspawn_node.global_position

func get_wand_transform() -> Transform3D:
	return _wandspawn_node.global_transform

func get_pivot_basis() -> Basis:
	return _pivot.global_basis
