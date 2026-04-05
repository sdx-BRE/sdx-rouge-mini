class_name EnemyAbilitySystem extends RefCounted

var _registry: EnemyAbilityRegistry
var _resolver: EnemyAbilityResolver
var _cooldown_manager: CooldownManager

func _init(
	registry: EnemyAbilityRegistry,
	resolver: EnemyAbilityResolver,
	cooldown_manager: CooldownManager,
) -> void:
	_registry = registry
	_resolver = resolver
	_cooldown_manager = cooldown_manager

func try_activate_ability(ability_id: int) -> void:
	var ability := _registry.get_ability(ability_id)
	if ability == null:
		push_warning("[WARN][AbilitySystem.try_activate_ability(%d)]: Ability not found!" % ability_id)
		return
	
	var handler := _resolver.resolve(ability)
	if handler != null and not _cooldown_manager.has_enemy_cooldown(ability):
		handler.try_activate()

func execute_cast() -> void:
	_resolver.execute_cast()

func tick(delta: float) -> void:
	_cooldown_manager.tick(delta)

func has_cooldown(ability_id: int) -> bool:
	return _cooldown_manager.has_cooldown(ability_id)
