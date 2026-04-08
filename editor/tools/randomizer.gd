@tool
extends Node3D

const CARDINAL := [0.0, 90.0, 180,0, 270.0]
const OCTAL := [0.0, 45.0, 90,0, 135.0, 180,0, 225.0, 270.0]

enum RotationSnap {
	Free,
	Cardinal,
	Octal,
}

enum TargetMode {
	Node,
	Children,
}

@export_tool_button("Randomize Y-Rotation", "Callable") var btn_rotate_y := _randomize_rotation_y
@export var snap_mode := RotationSnap.Free
@export var target_mode: TargetMode = TargetMode.Node
@export var node: Node3D

func _randomize_rotation_y() -> void:
	var target = node if node != null else self
	
	if target_mode == TargetMode.Node:
		_rotate_y(target)
	elif target_mode == TargetMode.Children:
		for child in target.get_children():
			_rotate_y(child)

func _rotate_y(target_node: Node3D) -> void:
	var degree: float
	match snap_mode:
		RotationSnap.Free:
			degree = randf_range(-180.0, 180.0)
		RotationSnap.Cardinal:
			degree = _rng_element(CARDINAL)
		RotationSnap.Octal:
			degree = _rng_element(OCTAL)
	
	target_node.rotation.y = deg_to_rad(degree)

func _rng_element(array: Array) -> Variant:
	return array[randi_range(0, array.size() - 1)]
