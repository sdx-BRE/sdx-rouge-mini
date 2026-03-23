@tool
class_name ApplyVisualLayersUtil extends Node

@export_tool_button("Apply VisualInstance3D layers", "Callable") var set_all_layers_btn = set_all_layer_masks
@export_flags_3d_render var visual_layers: int = 1
@export var use_mesh_name_prefix: bool = false
@export var mesh_name_prefix: String = ""

func set_all_layer_masks():
	var names = []
	for mesh in _get_all_mesh_instances(self):
		if use_mesh_name_prefix and not mesh.name.begins_with(mesh_name_prefix):
			continue
		
		mesh.layers = visual_layers
		names.append(mesh.name)
	DbgHelper.tool_tprint("Applied visual layers to %s" % ", ".join(names))

func _get_all_mesh_instances(node: Node) -> Array[MeshInstance3D]:
	var result: Array[MeshInstance3D] = []
	for child in node.get_children():
		if child is MeshInstance3D:
			result.append(child)
		result.append_array(_get_all_mesh_instances(child))
	return result
