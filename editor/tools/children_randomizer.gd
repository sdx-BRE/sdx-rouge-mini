@tool
extends Node3D

@export_tool_button("Randomize", "Callable") var rng_btn := _randomize
@export_tool_button("Randomize rotation", "Callable") var rng_btn_rotate := _randomize_rotations
@export_tool_button("Randomize height", "Callable") var rng_btn_heights := _randomize_heights

@export var excludes_rotate_y: Array[StringName] = []
@export var invert_rotate: bool = false
@export_range(-180.0, 180.0) var min_rotate_y: float = -180.0
@export_range(-180.0, 180.0) var max_rotate_y: float = 180.0

@export var excludes_height: Array[StringName] = []
@export var invert_height: bool = false
@export_range(0.1, 1.0) var min_height: float = 0.5
@export_range(0.1, 1.0) var max_height: float = 1.0

func _randomize() -> void:
	_randomize_rotations()
	_randomize_heights()
	DbgHelper.tool_tprint("Nodes randomized!")

func _randomize_rotations() -> void:
	get_children() \
		.filter(_filter_rotate_y) \
		.map(_randomize_rotation_y)
	DbgHelper.tool_tprint("Nodes rotated!")

func _randomize_heights() -> void:
	get_children() \
		.filter(_filter_height) \
		.map(_randomize_height)
	DbgHelper.tool_tprint("Nodes height randomized!")

func _randomize_rotation_y(node: MeshInstance3D) -> void:
	node.rotation.y = deg_to_rad(randf_range(min_rotate_y, max_rotate_y))

func _randomize_height(node: MeshInstance3D) -> void:
	var height := randf_range(min_height, max_height)
	var pos_y := height * 0.5
	
	(node.mesh as CylinderMesh).height = height
	node.position.y = pos_y

func _filter_rotate_y(node: Node) -> bool:
	return _filter_nodes(node, excludes_rotate_y, invert_rotate)

func _filter_height(node: Node) -> bool:
	return _filter_nodes(node, excludes_height, invert_height)

func _filter_nodes(node: Node, excludes: Array[StringName], invert: bool) -> bool:
	if excludes.has(node.name) != invert:
		return false
	
	if not node is MeshInstance3D:
		return false
	node = node as MeshInstance3D
	
	if not node.mesh is CylinderMesh:
		return false
	
	return true
