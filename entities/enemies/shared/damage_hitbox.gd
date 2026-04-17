class_name DamageHitbox extends Area3D

@export var entity: CharacterBody3D

func take_dmg(value: float) -> void:
	DamageGateway.display_damage.emit(value, global_position)
	
	if entity != null and entity.has_method("take_dmg"):
		entity.take_dmg(value)
	elif get_parent().has_method("take_dmg"):
		get_parent().take_dmg(value)
	else:
		push_error("[ERROR][DamageHitbox.take_dmg()] - could not delegate damage to entity!")
