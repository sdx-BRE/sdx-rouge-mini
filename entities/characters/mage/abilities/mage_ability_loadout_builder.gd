class_name MageAbilityLoadoutBuilder extends RefCounted

var _mage: MageCharacter
var _controller: MageController
var _context: MageAbilityContext
var _anim_player: AnimationPlayer
var _registry: MageAbilityRegistry

var _base_cost := MageAbilityCost.new(0, 0)

func _init(mage: MageCharacter, controller: MageController) -> void:
	_mage = mage
	_controller = controller
	_context = MageAbilityContext.new(mage)
	_anim_player = mage.anim_tree.get_node(mage.anim_tree.anim_player)
	_registry = MageAbilityRegistry.new()

func add_spell(
	id: MageAbilityId.Id, 
	ability_class: Script, 
	mana_cost: int, 
	spell_data: SpellResource,
	spell_anim: SpellAnimationData, 
	inputs: Array[StringName]
) -> MageAbilityLoadoutBuilder:
	var cost := _base_cost.with_mana(mana_cost)
	var anim := MageSpellAnimation.create(spell_data, spell_anim, _anim_player)
	
	var ability: MageAbilitySpell = ability_class.new(_controller, _context, cost, anim)
	_registry.add(id, MageAbilityInfo.new(ability, inputs))
	
	return self

func add_instant_animated(
	id: MageAbilityId.Id,
	ability_class: Script,
	stamina_cost: int,
	anim_data: MageAnimationData,
	inputs: Array[StringName]
) -> MageAbilityLoadoutBuilder:
	var cost := _base_cost.with_stamina(stamina_cost)
	var anim := MageAbilityAnimation.from_data(anim_data)
	
	var ability: MageAbilityInstantAnimated = ability_class.new(_controller, _context, cost, anim)
	_registry.add(id, MageAbilityInfo.new(ability, inputs))
	
	return self

func build() -> MageAbilityHandler:
	return MageAbilityHandler.new(_registry)
