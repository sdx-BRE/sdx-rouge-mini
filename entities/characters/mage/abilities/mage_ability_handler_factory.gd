class_name MageAbilityHandlerFactory

static func create(mage: MageCharacter, controller: MageController) -> MageAbilityHandler:
	var player: AnimationPlayer = mage.anim_tree.get_node(mage.anim_tree.anim_player)
	var context := MageAbilityContext.new(mage)
	
	var empty_cost := MageAbilityCost.new(0, 0)

	var firebolt := MageAbilityFirebolt.new(controller, context, empty_cost.with_mana(5), MageSpellAnimation.create(
		mage.firebolt_data,
		mage.animation_shoot,
		player,
	))
	
	var firepulse := MageAbilityFirepulse.new(controller, context, empty_cost.with_mana(2), MageSpellAnimation.create(
		mage.firepulse_data,
		mage.animation_shoot,
		player,
	))
	
	var meteor := MageAbilityMeteor.new(controller, context, empty_cost.with_mana(15), MageSpellAnimation.create(
		mage.meteor_data,
		mage.animation_raise,
		player,
	))
	
	var dash := MageAbilityDash.new(controller, context, empty_cost.with_stamina(5))
	
	var registry := MageAbilityRegistry.new()
	registry.add(MageAbilityId.Id.Firepulse, MageAbilityInfo.new(firepulse, ["attack", "skill_2"]))
	registry.add(MageAbilityId.Id.Firebolt, MageAbilityInfo.new(firebolt, ["skill_1"]))
	registry.add(MageAbilityId.Id.Meteor, MageAbilityInfo.new(meteor, ["skill_3"]))
	registry.add(MageAbilityId.Id.Dash, MageAbilityInfo.new(dash, ["dash"]))
	
	return MageAbilityHandler.new(registry)
