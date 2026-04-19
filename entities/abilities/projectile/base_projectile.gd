class_name BaseProjectile extends AbilityEntity

enum Homing {
	Disabled,
	Simple,
	Predictive,
}

var _damage: AbilityDamage
var _speed: float
var _lifetime: float
var _homing: Homing = Homing.Disabled
var _homing_strategy: ProjectileHomingBase
var _homing_fov: float
var _homing_steer_speed: float
var _target: Node3D

@onready var timer := $Timer

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	timer.timeout.connect(queue_free)
	
	timer.wait_time = _lifetime
	timer.start()
	
	_homing_strategy = ProjectileHomingResolver.resolve(_homing, self, _target)

func _process(delta: float) -> void:
	_homing_strategy.steer(delta)
	_move(delta)

func _move(delta: float) -> void:
	global_position += -global_basis.z * _speed * delta

func launch_enemy_ability(_data: AbilityDelivery, context: AbilityExecuteContext) -> void:
	global_position = context.get_weapon_spawn_node().global_position
	global_basis = context.get_pivot_basis()

func setup_enemy_ability(data: AbilityDelivery, _context: AbilityExecuteContext) -> void:
	var projectile_data := data as AbilityDeliveryProjectile
	if not projectile_data:
		return
	
	_damage = projectile_data.damage
	_speed = projectile_data.speed
	_lifetime = projectile_data.lifetime
	_homing = projectile_data.homing
	_homing_fov = projectile_data.homing_fov
	_homing_steer_speed = projectile_data.homing_steer_speed
	
	collision_mask = Layers.COLLISION_PLAYER_DAMAGE

func setup_character_ability(data: AbilityDelivery, _context: AbilityExecuteContext) -> void:
	var projectile_data := data as AbilityDeliveryProjectile
	if not projectile_data:
		return
	
	_damage = projectile_data.damage
	_speed = projectile_data.speed
	_lifetime = projectile_data.lifetime
	_homing = projectile_data.homing
	_homing_fov = projectile_data.homing_fov
	_homing_steer_speed = projectile_data.homing_steer_speed
	
	collision_mask = Layers.COLLISION_ENEMY_DAMAGE

func _on_area_entered(body: Node3D) -> void:
	if body.has_method("take_damage"):
		var hit := DamageInstance.from_ability(_damage)
		body.take_damage(hit)
		queue_free()
