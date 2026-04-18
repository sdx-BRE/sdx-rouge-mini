class_name ContinuousAbility extends AbilityEntity

var _damage: float

var _targets: Array[Node3D] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func setup_enemy_ability(data: AbilityDelivery, _context: AbilityExecuteContext) -> void:
	collision_layer = Layers.COLLISION_ENEMY_SPELL
	collision_mask = Layers.COLLISION_PLAYER_DAMAGE
	
	var continuous_data := data as AbilityDeliveryContinuous
	if continuous_data:
		_damage = continuous_data.damage

func setup_character_ability(data: AbilityDelivery, _context: AbilityExecuteContext) -> void:
	collision_layer = Layers.COLLISION_PLAYER_SPELL
	collision_mask = Layers.COLLISION_ENEMY_DAMAGE
	
	var continuous_data := data as AbilityDeliveryContinuous
	if continuous_data:
		_damage = continuous_data.damage

func tick_damage() -> void:
	for target in _targets:
		if target.has_method("take_dmg"):
			target.take_dmg(_damage)

func _on_area_entered(body: Node3D) -> void:
	_targets.append(body)

func _on_area_exited(body: Node3D) -> void:
	_targets.erase(body)
