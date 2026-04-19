class_name DamageHitbox extends Area3D

@export var entity: CharacterBody3D

func take_damage(hit: DamageInstance) -> void:
	DamageGateway.display_damage.emit(hit.amount, global_position)
	
	if entity != null and entity.has_method("take_damage"):
		entity.take_damage(hit)
	elif get_parent().has_method("take_damage"):
		get_parent().take_damage(hit)
	else:
		push_error("[ERROR][DamageHitbox.take_damage()] - could not delegate damage to entity!")
