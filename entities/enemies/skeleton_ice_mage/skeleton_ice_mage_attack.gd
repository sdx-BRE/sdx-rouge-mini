class_name SkeletonIceMageAttack extends StateContextAttack

const ICE_BOLT := &"ice_bolt"
const GLACIAL_SPIKE := &"glacial_spike"

const PRIORITIES: Array[StringName] = [GLACIAL_SPIKE, ICE_BOLT]

var _abilities: AbilitySystem

func _init(abilities: AbilitySystem) -> void:
	_abilities = abilities
	_abilities.ability_finished.connect(_on_ability_finished)

func try_attack(context: StateContext) -> void:
	context.rotate_to_target()
	
	if not context.can_attack() or _abilities.is_any_ability_active():
		return
	
	for id in PRIORITIES:
		if _abilities.can_activate_ability(id) and _abilities.try_activate_ability(id):
				break

func _on_ability_finished(_ability: Ability) -> void:
	_emit_attacked()
