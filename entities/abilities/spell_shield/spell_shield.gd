extends AbilityEntity

const DEFAULT_DURATION := 5.0

var _taget_collision_mask: int

var _age := 0.0
var threshold := 0.5

func _process(delta: float) -> void:
	_age += delta

func setup_enemy_ability(ability: EnemyCastAbility, context: EnemyAbilityContextCast) -> void:
	super(ability, context)
	_taget_collision_mask = Layers.COLLISION_PLAYER_DAMAGE

func launch_enemy_ability(_ability: EnemyCastAbility, _context: EnemyAbilityContextCast) -> void:
	get_tree().create_timer(DEFAULT_DURATION).timeout.connect(queue_free)

func setup_character_ability(_data: CharacterAbilityEffect, _context: CharacterAbilityExecutionExecuteContext) -> void:
	_taget_collision_mask = Layers.COLLISION_PLAYER_DAMAGE

func launch_character_ability(data: CharacterAbilityEffect, _context: CharacterAbilityExecutionExecuteContext) -> void:
	var buff_data := data as CharacterAbilityEffectBuff
	
	var duration: float
	if not buff_data:
		push_error(DbgHelper.err("SpellShield.launch_character_ability", "data arg MUST be CharacterAbilityEffect"))
		duration = DEFAULT_DURATION
	else:
		duration = buff_data.duration
	
	get_tree().create_timer(duration).timeout.connect(queue_free)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(body: Node3D) -> void:
	if not body is BaseProjectile:
		return
	
	if _age <= threshold:
		_reflect_projectile(body)
	else:
		body.queue_free()

func _reflect_projectile(projectile: BaseProjectile) -> void:
	var forward := -projectile.global_basis.z
	projectile.look_at(projectile.global_position - forward, Vector3.UP)
	
	projectile.collision_mask = _taget_collision_mask
