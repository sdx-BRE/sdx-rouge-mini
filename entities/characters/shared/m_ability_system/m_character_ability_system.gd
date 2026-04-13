## 	Idea:
## 
##	Four steps:
##		1. Targeting (None, Mouse Target, Location, Direction)
##		2. Trigger (Normal, Channeled, Charged)
##		3. Windup (Animated, Instant)
##		4. Execution/effect (Projectile, AoE, Buff)
## 
class_name MCharacterAbilitySystem extends RefCounted

var _registry: MCharacterAbilityRegistry
var _manager: MCharacterAbilityManager
var _cooldown_manager: CooldownManager

func _init(
	registry: MCharacterAbilityRegistry,
	manager: MCharacterAbilityManager,
	cooldown_manager: CooldownManager,
) -> void:
	_registry = registry
	_manager = manager
	_cooldown_manager = cooldown_manager

func handle_input(event: InputEvent) -> bool:
	if event.is_echo():
		return false
	
	if _manager.is_handling_active_ability(event):
		return true
	
	var actions := _registry.get_actions()
	for action in actions:
		if event.is_action(action):
			var state := MCharacterAbilitySystem.TriggerState.Press if event.is_pressed() else MCharacterAbilitySystem.TriggerState.Release
			
			handle_ability_action(actions[action], state)
			return true
	
	return false

func notify_animation_event() -> void:
	_manager.handle_animation_event()

func use_ability_resources(id: int) -> void:
	var ability := _registry.get_ability(id)
	if ability == null:
		return
	
	ability.use_resources()

func has_ability_resources(id: int) -> bool:
	var ability := _registry.get_ability(id)
	if ability == null:
		return false
	
	return ability.has_resources()

func tick(delta: float) -> void:
	_manager.tick(delta)
	#_cooldown_manager.tick(delta)

enum TriggerState {
	Press,
	Release,
}

func handle_ability_action(
	id: int,
	state: TriggerState,
) -> void:
	var ability := _registry.get_ability(id)
	
	if ability == null:
		return
	
	if state == TriggerState.Press:
		if not ability.check_resources():
			return
	
	_manager.handle_ability_action(ability, state)
