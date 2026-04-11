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
var _cooldown_manager: CooldownManager

func _init(
	registry: MCharacterAbilityRegistry,
	cooldown_manager: CooldownManager,
) -> void:
	_registry = registry
	_cooldown_manager = cooldown_manager

func handle_input(event: InputEvent) -> bool:
	if event.is_echo():
		return false
	
#	if _manager.is_handling_active_ability(event):
#		return true
#	
	var actions := _registry.get_actions()
	for action in actions:
		if event.is_action(action):
			var state := MCharacterAbilitySystem.TriggerState.Press if event.is_pressed() else MCharacterAbilitySystem.TriggerState.Release
			
			_try_activate_ability(actions[action], state)
			return true
	
	return false

func execute_buffered_ability() -> void:
	pass#_manager.execute_buffered_ability()

func on_ability_triggered(id: int) -> void:
	pass
#	var ability := _registry.get_ability(id)
#	if ability == null:
#		return
#	
#	ability.use_resources()

func has_resources(id: int) -> bool:
#	var ability := _registry.get_ability(id)
#	if ability == null:
#		return false
	return false
#	return ability.has_resources()

func tick(delta: float) -> void:
	pass#_manager.tick(delta)
	#_cooldown_manager.tick(delta)

enum TriggerState {
	Press,
	Release,
}

func _try_activate_ability(
	id: int,
	state: TriggerState,
) -> void:
	print("try activate id: ", id, " - state: ", TriggerState.keys()[state])
	pass
