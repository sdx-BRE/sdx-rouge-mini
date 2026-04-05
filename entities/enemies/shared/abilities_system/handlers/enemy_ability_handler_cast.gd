class_name EnemyAbilityHandlerCast extends EnemyAbilityHandler

var _ctx: EnemyAbilityContextCast
var _cooldown_manager: CooldownManager
var _ability: EnemyCastAbility

func _init(
	ctx: EnemyAbilityContextCast,
	cooldown_manager: CooldownManager,
) -> void:
	_ctx = ctx
	_cooldown_manager = cooldown_manager

func setup(ability: EnemyBaseAbility) -> EnemyAbilityHandler:
	_ability = ability as EnemyCastAbility
	return self

func try_activate() -> void:
	if _ability.disabled:
		_cooldown_manager.start_enemy_cooldown(_ability)
		return
	
	if _ability.anim_type == EnemyCastAbility.AnimType.Oneshot:
		_ctx.play_oneshot_anim(_ability.anim_trigger)

func execute() -> void:
	if _ability == null:
		return
	
	var node := _ability.scene.instantiate()
	if _ability is EnemyCastAbility and node is AbilityEntity:
		_setup_ability(_ability, node)
	
	_ability = null

func _setup_ability(ability: EnemyCastAbility, node: AbilityEntity):
	node.collision_mask = ability.collision_mask
	
	node.setup_enemy_ability(ability, _ctx)
	_ctx.spawn_node(node)
	node.launch_enemy_ability(ability, _ctx)
	
	_cooldown_manager.start_enemy_cooldown(ability)
