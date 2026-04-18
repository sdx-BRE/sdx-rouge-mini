class_name BaseAoe extends AbilityEntity

var _damage: float
var _delay: float
var _radius: float

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(body: Node3D) -> void:
	if body.has_method("take_dmg"):
		body.take_dmg(_damage)

func launch_enemy_ability(_data: AbilityDelivery, _context: AbilityExecuteContext) -> void:
	pass

func setup_enemy_ability(data: AbilityDelivery, _context: AbilityExecuteContext) -> void:
	var aoe_data := data as AbilityDeliveryAoe
	if not aoe_data:
		push_error(_err("setup()", "data arg MUST be AbilityDeliveryAoe"))
		return
	
	_damage = aoe_data.damage
	_delay = aoe_data.delay
	_radius = aoe_data.radius

func setup_character_ability(data: AbilityDelivery, _context: AbilityExecuteContext) -> void:
	var aoe_data := data as AbilityDeliveryAoe
	if not aoe_data:
		push_error(_err("setup()", "ability arg MUST be AbilityDelivery"))
		return
	_damage = aoe_data.damage
	_delay = aoe_data.delay
	_radius = aoe_data.radius

func _err(method: String, msg: String) -> String:
	return DbgHelper.err("BaseAoe.%s" % method, msg)
