class_name BaseAoe extends AbilityEntity

var _damage: float
var _delay: float
var _radius: float

func launch_ability(ability: EnemyCastAbility, context: EnemyAbilityContextCast) -> void:
	var data := ability as EnemyCastAbilityArea
	if not data:
		push_error(_err("launch_ability()", "ability arg MUST be CastAbiltiyArea"))
		return
	
	global_position = context.get_target_position()
	
	_damage = data.damage
	_delay = data.delay
	_radius = data.radius

func _err(method: String, msg: String) -> String:
	return DbgHelper.err("BaseAoe.%s" % method, msg)
