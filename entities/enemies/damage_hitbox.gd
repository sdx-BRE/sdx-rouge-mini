class_name DamageHitbox extends Area3D

@export var entity: CharacterBody3D

func take_dmg(value: float) -> void:
	if entity.has_method("take_dmg"):
		entity.take_dmg(value)
