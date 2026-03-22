extends Area3D

@export var speed: float = 20.0
@export var lifespan: float = 5.0
@export var dmg: float = 15

func _ready() -> void:
	get_tree().create_timer(lifespan).timeout.connect(queue_free)
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	var forward = -global_transform.basis.z
	global_position += forward * speed * delta

func _on_area_entered(body: Node3D) -> void:
	var hitbox = body as DamageHitbox
	if hitbox != null:
		hitbox.take_dmg(dmg)
	
	queue_free()
