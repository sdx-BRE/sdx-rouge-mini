class_name Firebolt extends Area3D

@export var speed: float = 20.0
@export var lifespan: float = 5.0
@export var damage: float = 15.0
@export var homing_steer_speed := 1.5
@export var homing_fov := -0.6

var _target: Node3D

func _ready() -> void:
	get_tree().create_timer(lifespan).timeout.connect(queue_free)
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if _target == null:
		push_warning("[Firebolt].process() - no target set!")
		queue_free()
		return
	
	var forward := -global_transform.basis.z
	
	_smooth_look_at(_target.global_position, forward, delta)
	global_position += forward * speed * delta

func _smooth_look_at(target_pos: Vector3, forward: Vector3, delta: float) -> void:
	var direction := (target_pos - global_position).normalized()
	
	var dot := forward.dot(direction)
	if dot > homing_fov:
		var target_transform := global_transform.looking_at(target_pos, Vector3.UP)
		global_transform.basis = global_transform.basis \
			.slerp(target_transform.basis, delta * homing_steer_speed) \
			.orthonormalized()

func _on_area_entered(body: Node3D) -> void:
	var hitbox := body as DamageHitbox
	if hitbox != null:
		hitbox.take_dmg(damage)
	
	queue_free()

func set_target(target: Node3D) -> void:
	_target = target
