class_name BaseProjectile extends AbilityEntity

enum Homing {
	Disabled,
	Simple,
	Predictive,
}

var _damage: float
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

func launch_enemy_ability(_ability: EnemyCastAbility, context: EnemyAbilityContextCast) -> void:
	global_position = context.get_cast_position()
	global_basis = context.get_pivot_basis()

func setup_enemy_ability(ability: EnemyCastAbility, context: EnemyAbilityContextCast) -> void:
	var data := ability as EnemyCastProjectileAbility
	if not data:
		return
	
	_damage = data.damage
	_speed = data.speed
	_lifetime = data.lifetime
	_homing = data.homing
	_homing_fov = data.homing_fov
	_homing_steer_speed = data.homing_steer_speed
	_target = context.get_target()

func setup_character_ability(data: CharacterAbilityEffect, _context: CharacterAbilityExecutionExecuteContext) -> void:
	var projectile_data := data as CharacterAbilityEffectProjectile
	if not projectile_data:
		return
	
	_damage = projectile_data.damage
	_speed = projectile_data.speed
	_lifetime = projectile_data.lifetime
	_homing = projectile_data.homing
	_homing_fov = projectile_data.homing_fov
	_homing_steer_speed = projectile_data.homing_steer_speed

func _on_area_entered(body: Node3D) -> void:
	if body.has_method("take_dmg"):
		body.take_dmg(_damage)
		queue_free()
