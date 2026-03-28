class_name MageAbilityHandler extends RefCounted

const INPUT_FIREPULSE: Array[StringName] = [MageAbilityActions.ACTION_FIREPULSE]
const INPUT_FIREBOLT: Array[StringName] = [MageAbilityActions.ACTION_FIREBOLT]
const INPUT_METEOR: Array[StringName] = [MageAbilityActions.ACTION_METEOR]
const INPUT_DASH: Array[StringName] = [MageAbilityActions.ACTION_DASH]
const INPUT_JUMP: Array[StringName] = [MageAbilityActions.ACTION_JUMP]

var _registry: MageAbilityRegistry

var _active: MageAbilityPhased
var _buffered: MageAbilityPhased

func _init(registry: MageAbilityRegistry) -> void:
	_registry = registry

static func create(
	mage: MageCharacter, 
	anim: MageAnimator, 
	stats: MageStats, 
	controller: MageController,
	notify_started: Signal,
	notify_progressed: Signal,
	notify_end: Signal,
) -> MageAbilityHandler:
	var anim_player: AnimationPlayer = mage.anim_tree.get_node(mage.anim_tree.anim_player)
	var context_environment := MageAbilityContextEnvironment.from_mage(mage, notify_started, notify_progressed, notify_end)
	var context_data := MageAbilityContextData.from_mage(mage)
	var context := MageAbilityContext.new(anim, stats, context_data, context_environment)
	var builder := MageAbilityLoadoutBuilder.new(context, controller, anim_player)
	
	return builder \
		.add_spell(MageAbilityId.Id.Firepulse, MageAbilityFirepulse, 2, mage.firepulse_data, mage.animation_shoot, INPUT_FIREPULSE) \
		.add_spell(MageAbilityId.Id.Firebolt, MageAbilityFirebolt, 5, mage.firebolt_data, mage.animation_shoot, INPUT_FIREBOLT) \
		.add_spell(MageAbilityId.Id.Meteor, MageAbilityMeteor, 15, mage.meteor_data, mage.animation_raise, INPUT_METEOR) \
		.add_instant_animated(MageAbilityId.Id.Dash, MageAbilityDash, 5, mage.animation_dash, INPUT_DASH) \
		.add_instant(MageAbilityId.Id.Jump, MageAbilityJump, 10, INPUT_JUMP) \
		.build()

func try_activate_ability(
	id: MageAbilityId.Id, 
	state: MageAbilityBase.TriggerState = MageAbilityBase.TriggerState.PRESS,
) -> void:
	var ability: MageAbilityBase = _registry.get_ability(id)
	
	if ability == null:
		return
	
	if not ability.has_resources():
		return
	
	if ability is MageAbilityInstant:
		if ability.trigger(state) == MageAbilityInstant.Result.Trigger:
			ability.use_resources()
		return
	
	if state != MageAbilityBase.TriggerState.PRESS:
		return
	
	if _active != null:
		_active.cancel()
	_active = ability
	
	var result := _active.start()
	if result == MageAbilityPhased.StartResult.BufferAbility:
		_buffer_active_ability()

func process_abilities(delta: float) -> void:
	if _active != null:
		_active.update(delta)
	
	if _buffered != null:
		_buffered.tick_cast(delta)

func handle_input(event: InputEvent) -> bool:
	if event.is_echo():
		return false
	
	if _active != null:
		var handle_result := _active.handle_input(event)
		if _is_input_handled(handle_result):
			match handle_result:
				MageAbilityPhased.HandleInputResult.Trigger: _buffer_active_ability()
				MageAbilityPhased.HandleInputResult.Cancel: _cancel_active_ability()
			
			return true
	
	var actions := _registry.get_actions()
	for action in actions:
		if event.is_action(action):
			var state := MageAbilityBase.TriggerState.PRESS if event.is_pressed() else MageAbilityBase.TriggerState.RELEASE
			
			try_activate_ability(actions[action], state)
			return true
	
	return false

func execute_buffered_ability() -> void:
	if _buffered != null:
		_buffered.execute()
		_buffered.use_resources()
		_buffered = null

func _buffer_active_ability() -> void:
	if _active != null:
		_buffer_ability(_active)
		_active = null

func _buffer_ability(ability: MageAbilityBase) -> void:
	if _buffered != null:
		_buffered.cancel()
	_buffered = ability

func _cancel_active_ability() -> void:
	if _active != null:
		_active.cancel()
	_active = null

func _is_input_handled(result: MageAbilityPhased.HandleInputResult) -> bool:
	return result == MageAbilityPhased.HandleInputResult.Trigger or result == MageAbilityPhased.HandleInputResult.Cancel
