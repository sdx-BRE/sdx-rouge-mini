@tool
class_name MultiMesher extends Node

@export_tool_button("Apply instance transformations", "Callable") var btn_rotate_y := _apply_transformations

@export var multimesh: MultiMeshInstance3D
@export var mesh: Mesh
@export var source_container: Node3D

func _apply_transformations() -> void:
	if not _valid_exports():
		return
	
	var transforms := _get_transforms(source_container)
	var mm := MultiMesh.new()
	
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.instance_count = transforms.size()
	mm.mesh = mesh
	
	for idx in range(0, transforms.size()):
		var transform := transforms[idx]
		mm.set_instance_transform(idx, transform)
	
	multimesh.multimesh = mm
	DbgHelper.tprint("Applied multimesh instance transformations")

func _get_transforms(node: Node) -> Array[Transform3D]:
	var transforms: Array[Transform3D] = []
	
	for child in node.get_children():
		if child is MeshInstance3D:
			transforms.append(child.global_transform)
		elif child is Node:
			transforms.append_array(_get_transforms(child))
	
	return transforms

func _valid_exports() -> bool:
	var msg: Array[String] = []
	
	if multimesh == null:
		msg.append("required multimesh (MultiMeshInstance3D)")
	
	if mesh == null:
		msg.append("required mesh (Mesh)")
	
	if source_container == null:
		msg.append("required source_container (Node3D)")
	
	if msg.size() > 0:
		var separator := "\n\t"
		var err := "\nInvalid @export:%s%s" % [separator, separator.join(msg)]
		
		push_error(err)
	
	return msg.size() == 0
