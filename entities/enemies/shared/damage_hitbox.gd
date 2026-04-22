class_name DamageHitbox extends Area3D

@export var entity: CharacterBody3D

func take_damage(hit: DamageInstance) -> void:
	if entity != null and entity.has_method("take_damage"):
		entity.take_damage(hit)
	elif get_parent().has_method("take_damage"):
		get_parent().take_damage(hit)
	else:
		push_error("[ERROR][DamageHitbox.take_damage()] - could not delegate damage to entity!")

func get_target_point() -> Node3D:
	if entity != null and entity.has_method("get_target_point"):
		return entity.get_target_point()
	return self
