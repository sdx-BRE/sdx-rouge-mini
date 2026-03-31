extends Area3D

@export var dmg := 3.5
@export var speed := 0.30

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(body: Node3D) -> void:
	if body.has_method("take_dmg"):
		body.take_dmg(dmg)

func _process(delta: float) -> void:
	var forward := -global_basis.z
	
	global_position += forward * speed * delta

func set_target(_target): pass
