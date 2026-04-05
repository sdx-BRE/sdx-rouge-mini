class_name BaseProjectile extends AbilityEntity

var _damage: float
var _speed: float
var _lifetime: float
var _enable_homing: bool
var _homing_fov: float
var _homing_steer_speed: float

@onready var timer := $Timer

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	timer.timeout.connect(queue_free)

func _process(delta: float) -> void:
	var forward := -global_basis.z
	global_position += forward * _speed * delta

func launch_ability(_ability: EnemyCastAbility, context: EnemyAbilityContextCast) -> void:
	global_position = context.get_cast_position()
	global_basis = context.get_host_basis()
	
	timer.wait_time = _lifetime
	timer.start()

func setup(ability: EnemyCastAbility, context: EnemyAbilityContextCast) -> void:
	var data := ability as EnemyCastProjectileAbility
	if not data:
		return
	
	_damage = data.damage
	_speed = data.speed
	_lifetime = data.lifetime
	_enable_homing = data.enable_homing
	_homing_fov = data.homing_fov
	_homing_steer_speed = data.homing_steer_speed

func _on_area_entered(body: Node3D) -> void:
	if body.has_method("take_dmg"):
		body.take_dmg(_damage)
		queue_free()
