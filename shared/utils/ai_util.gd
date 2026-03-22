class_name AiUtil

static func is_visible(target: Node3D, source: Node3D, fov_threshold: float) -> bool:
	var direction = (target.global_position
		- source.global_position).normalized()
	var dot = -source.global_transform.basis.z.dot(direction)
	
	return dot >= fov_threshold
