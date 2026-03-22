@tool
class_name DbgHelper
extends RefCounted

var _do_after_counter = 0
func do_after(cb: Callable, count: int) -> void:
	if _do_after_counter >= count:
		cb.call()
		_do_after_counter = 0
	else:
		_do_after_counter += 1

var _once_called = false
func only_once(cb: Callable):
	if not _once_called:
		cb.call()
		_once_called = true

var _call_every_count = 0
func call_every(cb: Callable, count: int, force: bool = false):
	if force:
		cb.call()
	
	if _call_every_count == 0:
		cb.call()
	_call_every_count += 1
	
	if _call_every_count == count:
		_call_every_count = 0

static func tprint(...args: Array) -> void:
	var msg = "".join(args)
	
	var t = Time.get_time_dict_from_system()
	var ms = Time.get_ticks_msec() % 1000
	var ts = "[%02d:%02d:%02d:%03d]" % [t.hour, t.minute, t.second, ms]
	print(ts, " ", str(msg))

static func visualize_fov(source: Node3D, fov_threshold: float, duration: float = 2.0, distance: float = 5.0):
	var node_name = "FOV_Debug_Timer_" + str(source.get_instance_id())
	var old_node = source.get_node_or_null(node_name)
	if old_node:
		old_node.queue_free()

	var debug_node = MeshInstance3D.new()
	debug_node.name = node_name
	source.add_child(debug_node)
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color.SPRING_GREEN
	mat.no_depth_test = true
	mat.render_priority = 10
	
	debug_node.material_override = mat
	
	var imm_mesh = ImmediateMesh.new()
	debug_node.mesh = imm_mesh
	
	var angle = acos(clamp(fov_threshold, -1.0, 1.0))
	var left = Vector3.FORWARD.rotated(Vector3.UP, angle) * distance
	var right = Vector3.FORWARD.rotated(Vector3.UP, -angle) * distance
	
	imm_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	imm_mesh.surface_add_vertex(Vector3.ZERO)
	imm_mesh.surface_add_vertex(left)
	imm_mesh.surface_add_vertex(Vector3.ZERO)
	imm_mesh.surface_add_vertex(right)
	imm_mesh.surface_add_vertex(left)
	imm_mesh.surface_add_vertex(right)
	imm_mesh.surface_end()
	
	source.get_tree().create_timer(duration).timeout.connect(
		func(): if is_instance_valid(debug_node): debug_node.queue_free()
	)
