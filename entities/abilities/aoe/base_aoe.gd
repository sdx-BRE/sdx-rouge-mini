class_name BaseAoe extends AbilityEntity

var _damage: float
var _delay: float
var _radius: float

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(body: Node3D) -> void:
	if body.has_method("take_dmg"):
		body.take_dmg(_damage)

func launch_enemy_ability(ability: EnemyCastAbility, context: EnemyAbilityContextCast) -> void:
	var data := ability as EnemyCastAbilityArea
	if not data:
		push_error(_err("launch_ability()", "ability arg MUST be CastAbiltiyArea"))
		return
	
	global_position = context.get_target_position()

func setup_enemy_ability(ability: EnemyCastAbility, _context: EnemyAbilityContextCast) -> void:
	var data := ability as EnemyCastAbilityArea
	if not data:
		push_error(_err("setup()", "ability arg MUST be CastAbiltiyArea"))
		return
	_damage = data.damage
	_delay = data.delay
	_radius = data.radius

func _err(method: String, msg: String) -> String:
	return DbgHelper.err("BaseAoe.%s" % method, msg)
