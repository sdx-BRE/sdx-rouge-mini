@tool
class_name BoundaryGenerator extends Node

enum Mode {
	Mesh,
	Multimesh,
}

@export var multi_mesh_instance: MultiMeshInstance3D
@export var mesh_container: Node3D
@export var mesh_node_name: String = "MeshInstance"
@export_tool_button("Generate boundary", "Callable") var btn := generate_boundary

@export var mode: Mode = Mode.Multimesh
@export var truncate_mesh_container := false
@export var mesh: Mesh
@export var arena_size: float = 50.0
@export var row_shift: float = 0.0
@export var spacing: float = 2.0
@export var scale_min: float = 0.8
@export var scale_max: float = 1.2
@export var y_offset: float = 0.5
@export var offset_along: float = 0.5
@export var offset_across: float = 0.2

func generate_boundary() -> void:
	if not mesh:
		push_error("Mesh is mandatory!")
		return
	
	match mode:
		Mode.Multimesh:
			_generate_multi_mesh_ring()
		Mode.Mesh:
			_generate_mesh_ring()

func _generate_mesh_ring() -> void:
	if not mesh_container:
		push_error("Container node must be set!")
		return
	
	if truncate_mesh_container:
		mesh_container.get_children().map(mesh_container.remove_child)
	
	var transforms := _generate_ring_transforms()
	for transform in transforms:
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = mesh
		
		mesh_container.add_child(mesh_instance)
		mesh_instance.owner = self.owner if self.owner else self
		mesh_instance.name = mesh_node_name
		mesh_instance.global_transform = transform


func _generate_multi_mesh_ring() -> void:
	if not multi_mesh_instance:
		push_error("MultiMeshInstance3D must be set!")
		return
	
	if multi_mesh_instance.multimesh == null:
		multi_mesh_instance.multimesh = MultiMesh.new()
	
	multi_mesh_instance.multimesh.mesh = mesh
	if multi_mesh_instance.multimesh.transform_format != MultiMesh.TRANSFORM_3D:
		multi_mesh_instance.multimesh.instance_count = 0
		multi_mesh_instance.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	
	multi_mesh_instance.multimesh.instance_count = _get_total_items_count()
	
	var transforms := _generate_ring_transforms()
	
	for idx in range(0, transforms.size()):
		var transform := transforms[idx]
		multi_mesh_instance.multimesh.set_instance_transform(idx, transform)

func _generate_ring_transforms() -> Array[Transform3D]:
	var count_per_side := int(arena_size / spacing)
	var half_size := arena_size / 2.0
	
	var top := _generate_transforms(Vector3(-half_size, 0, -half_size), Vector3(half_size, 0, -half_size), count_per_side)
	var right := _generate_transforms(Vector3(half_size, 0, -half_size), Vector3(half_size, 0, half_size), count_per_side)
	var bottom := _generate_transforms(Vector3(half_size, 0, half_size), Vector3(-half_size, 0, half_size), count_per_side)
	var left := _generate_transforms(Vector3(-half_size, 0, half_size), Vector3(-half_size, 0, -half_size), count_per_side)
	
	var transforms: Array[Transform3D] = []
	transforms.append_array(top)
	transforms.append_array(right)
	transforms.append_array(bottom)
	transforms.append_array(left)
	
	return transforms

func _generate_transforms(
	start_pos: Vector3,
	end_pos: Vector3,
	count_per_side: int,
) -> Array[Transform3D]:
	var transforms: Array[Transform3D] = []
	
	var edge_vector := end_pos - start_pos
	var dir := edge_vector.normalized()
	
	var perp := Vector3(-dir.z, 0, dir.x)
	
	for i in range(count_per_side):
		var t := float(i) / count_per_side
		var base_pos := start_pos.lerp(end_pos, t) + (dir * row_shift)
		
		var random_along := randf_range(-offset_along, offset_along)
		var random_across := randf_range(-offset_across, offset_across)
		
		var pos := base_pos + (dir * random_along) + (perp * random_across)
		
		var random_scale := randf_range(scale_min, scale_max)
		var random_rot := randf_range(0, TAU)
		
		var xform := Transform3D()
		xform = xform.rotated(Vector3.UP, random_rot)
		xform = xform.scaled(Vector3(random_scale, random_scale, random_scale))
		
		pos.y += y_offset 
		xform.origin = pos
		
		transforms.append(xform)
	
	return transforms

func _get_total_items_count() -> int:
	return int(arena_size / spacing) * 4
