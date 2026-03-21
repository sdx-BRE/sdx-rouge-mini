@tool
extends Node3D

@export_tool_button("Update Bounds", "Callable") var update_bounds_button = _update_bounds

@export_range(0.0, 1.0) var dissolve_amount: float = 0.0 : 
	set(value):
		dissolve_amount = value
		_update_materials("dissolve_amount", value)

@export var use_noise_emission: bool = false : 
	set(value):
		use_noise_emission = value
		_update_materials("use_noise_emission", value)

@export_range(0.0, 1.0) var noise_emission_threshold: float = 0.5 : 
	set(value):
		noise_emission_threshold = value
		_update_materials("noise_emission_threshold", value)

@export var noise_emission_scale: float = 1.0 : 
	set(value):
		noise_emission_scale = value
		_update_materials("noise_emission_scale", value)

@export var noise_emission_intensity: float = 1.0 : 
	set(value):
		noise_emission_intensity = value
		_update_materials("noise_emission_intensity", value)

@export var dissolve_material_resource: ShaderMaterial
@export_tool_button("Apply material", "Callable") var apply_material_button = apply_dissolve_material
@export_tool_button("Remove material", "Callable") var remove_material_button = remove_dissolve_material

var last_position: Vector3 = Vector3.ZERO

func _get_configuration_warnings():
	if dissolve_material_resource == null:
		return ["Dissolve shader material resource required!"]
	return []

func _ready():
	if Engine.is_editor_hint():
		_setup_editor_hints()
	_update_bounds()
	last_position = global_position

func _process(_delta):
	if global_position != last_position:
		_update_bounds()
		last_position = global_position

func _setup_editor_hints():
	pass

func apply_dissolve_material() -> void:
	_apply_material(dissolve_material_resource)

func remove_dissolve_material() -> void:
	var meshes = _get_all_mesh_instances(self)
	for mesh in meshes:
		mesh.material_override = null
	print("Removed materials")

func _apply_material(material: Resource):
	var meshes = _get_all_mesh_instances(self)
	for mesh in meshes:
		mesh.material_override = material
	print("Applied materials")

func _update_bounds():
	var meshes = _get_all_mesh_instances(self)
	if meshes.is_empty():
		return
	
	var first_mat: ShaderMaterial = null
	for m in meshes:
		first_mat = m.get_active_material(0) as ShaderMaterial
		if first_mat: break
		
	if not first_mat: return
	
	var direction = first_mat.get_shader_parameter("dissolve_direction")
	if direction == null: direction = Vector3(0, 1, 0)
	var dir = Vector3(direction).normalized()
	
	var noise_strength = first_mat.get_shader_parameter("noise_strength")
	if noise_strength == null: noise_strength = 0.25
	
	var edge_width = first_mat.get_shader_parameter("edge_width")
	if edge_width == null: edge_width = 0.05
	
	var padding = float(noise_strength) + float(edge_width)
	
	var bounds_min = INF
	var bounds_max = -INF
	
	# Gehe alle Ecken von allen Meshes durch
	for mesh in meshes:
		var aabb = mesh.mesh.get_aabb() if mesh.mesh else mesh.get_aabb()
		
		var corners = [
			aabb.position,
			aabb.position + Vector3(aabb.size.x, 0, 0),
			aabb.position + Vector3(0, aabb.size.y, 0),
			aabb.position + Vector3(0, 0, aabb.size.z),
			aabb.position + Vector3(aabb.size.x, aabb.size.y, 0),
			aabb.position + Vector3(aabb.size.x, 0, aabb.size.z),
			aabb.position + Vector3(0, aabb.size.y, aabb.size.z),
			aabb.end
		]
		
		for corner in corners:
			var world_corner = mesh.global_transform * corner
			var projection = world_corner.x * abs(dir.x) + world_corner.y * abs(dir.y) + world_corner.z * abs(dir.z)
			
			bounds_min = min(bounds_min, projection)
			bounds_max = max(bounds_max, projection)
			
	bounds_min -= padding
	bounds_max += padding
	
	_update_materials("object_min", bounds_min)
	_update_materials("object_max", bounds_max)

# recursively loads all mesh instances from node
func _get_all_mesh_instances(node: Node) -> Array[MeshInstance3D]:
	var result: Array[MeshInstance3D] = []
	for child in node.get_children():
		if child is MeshInstance3D:
			result.append(child)
		result.append_array(_get_all_mesh_instances(child))
	return result

func _update_materials(param_name: String, value: Variant):
	var meshes = _get_all_mesh_instances(self)
	for mesh in meshes:
		var mat = mesh.material_override as ShaderMaterial
		
		if not mat:
			mat = mesh.get_active_material(0) as ShaderMaterial
			
		if mat:
			mat.set_shader_parameter(param_name, value)
