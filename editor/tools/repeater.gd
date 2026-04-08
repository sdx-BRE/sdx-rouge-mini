@tool
extends Node3D

enum Direction {
	POS_X,
	NEG_X,
	POS_Z,
	NEG_Z,
}

@export_tool_button("Randomize height", "Callable") var btn := _repeat
@export var container: Node3D
@export var source: Node3D
@export var count: int = 3
@export var min_distance: float = 3.0
@export var max_distance: float = 5.0
@export var steps: float = 0.5
@export var direction: Direction = Direction.POS_X

func _repeat() -> void:
	if not container:
		push_warning("Bitte weise zuerst einen Container im Inspector zu!")
		return
	
	var to_copy: Node3D = source
	for i in range(0, count):
		to_copy = _copy_node(to_copy)
	
	DbgHelper.tprint("Created '%d' copied." % count)

func _copy_node(node: Node3D) -> Node3D:
	var copy := node.duplicate()
	var random_dist = snapped(randf_range(min_distance, max_distance), steps)
	
	var offset := Vector3.ZERO
	match direction:
		Direction.POS_X: offset.x = random_dist
		Direction.NEG_X: offset.x = -random_dist
		Direction.POS_Z: offset.z = random_dist
		Direction.NEG_Z: offset.z = -random_dist
	
	container.add_child(copy)
	
	copy.owner = get_tree().edited_scene_root
	copy.global_position = node.global_position + offset
	copy.name = node.name
	
	return copy
