@tool
class_name FloorGenerator extends Node

enum Mode {
	Mesh,
	Multimesh,
}

@export_group("Nodes")
@export var multi_mesh_instance: MultiMeshInstance3D
@export var mesh_container: Node3D
@export var mesh_node_name: String = "MeshInstance"

@export_group("Settings")
@export var mode: Mode = Mode.Multimesh
@export var mesh: Mesh
@export var arena_size: float = 50.0
@export var tile_size: float = 2.0
@export var y_offset: float = 0.0

@export_group("Variation")
@export var randomize_rotation: bool = true
@export var truncate_mesh_container: bool = true

@export_tool_button("Generate Floor", "Callable") var btn := generate_floor

func generate_floor() -> void:
	if not mesh:
		push_error("Mesh is mandatory!")
		return
	
	match mode:
		Mode.Multimesh:
			_generate_multi_mesh_floor()
		Mode.Mesh:
			_generate_mesh_floor()

func _generate_mesh_floor() -> void:
	if not mesh_container:
		push_error("Container node must be set!")
		return
	
	if truncate_mesh_container:
		for child in mesh_container.get_children():
			mesh_container.remove_child(child)
			child.queue_free()
	
	var transforms := _generate_grid_transforms()
	for xform in transforms:
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = mesh
		mesh_container.add_child(mesh_instance)
		mesh_instance.owner = self.owner if self.owner else self
		mesh_instance.name = mesh_node_name
		mesh_instance.global_transform = xform

func _generate_multi_mesh_floor() -> void:
	if not multi_mesh_instance:
		push_error("MultiMeshInstance3D must be set!")
		return
	
	if multi_mesh_instance.multimesh == null:
		multi_mesh_instance.multimesh = MultiMesh.new()
	
	var transforms := _generate_grid_transforms()
	
	multi_mesh_instance.multimesh.mesh = mesh
	multi_mesh_instance.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multi_mesh_instance.multimesh.instance_count = transforms.size()
	
	for idx in range(transforms.size()):
		multi_mesh_instance.multimesh.set_instance_transform(idx, transforms[idx])

func _generate_grid_transforms() -> Array[Transform3D]:
	var transforms: Array[Transform3D] = []
	
	var count_per_side := int(ceil(arena_size / tile_size))
	var start_offset := -(arena_size / 2.0) + (tile_size / 2.0)
	
	for x in range(count_per_side):
		for z in range(count_per_side):
			var xform := Transform3D()
			
			if randomize_rotation:
				var steps := [0, PI/2, PI, PI * 1.5]
				var random_rot = steps[randi() % steps.size()]
				xform = xform.rotated(Vector3.UP, random_rot)
			
			var pos := Vector3(
				start_offset + (x * tile_size),
				y_offset,
				start_offset + (z * tile_size)
			)
			xform.origin = pos
			
			transforms.append(xform)
			
	return transforms
