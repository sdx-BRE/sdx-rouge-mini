extends Area3D

@export var dmg := 80.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _on_area_entered(body: Node3D) -> void:
	var hitbox = body as DamageHitbox
	if hitbox != null:
		hitbox.take_dmg(dmg)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Init":
		queue_free()
