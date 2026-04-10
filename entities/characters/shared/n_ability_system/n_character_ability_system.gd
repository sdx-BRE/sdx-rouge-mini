class_name NCharacterAbilitySystem extends RefCounted

var _registry: NCharacterAbilityRegistry
var _manager: NCharacterAbilityManager
var _cooldown_manager: CooldownManager

func _init(
	registry: NCharacterAbilityRegistry,
	manager: NCharacterAbilityManager,
	cooldown_manager: CooldownManager,
) -> void:
	_registry = registry
	_manager = manager
	_cooldown_manager = cooldown_manager

func handle_input(event: InputEvent) -> bool:
	#print("handle ")
	return false

func execute_buffered_ability() -> void:
	#print("NCharacterSystem.execute_buffered_ability()")
	pass

func on_ability_triggered(id: int) -> void:
	#print("NCharacterSystem.on_ability_triggered()")
	pass

func has_resources(id: int) -> bool:
	#print("NCharacterSystem.has_resources()")
	return false

func tick(delta: float) -> void:
	#print("NCharacterSystem.tick()")
	pass
