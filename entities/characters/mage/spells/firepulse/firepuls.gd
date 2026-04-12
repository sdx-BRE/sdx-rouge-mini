extends BaseAoe

@export var dmg := 30.0

func _ready() -> void:
	super()
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Init":
		queue_free()
