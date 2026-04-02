class_name AbilityHandlerCast extends AbilityHandler

var _ctx: AbilityContextCast
var _ability: CastAbility

func _init(
	ctx: AbilityContextCast,
) -> void:
	_ctx = ctx

func setup(ability: BaseAbility) -> AbilityHandler:
	_ability = ability as CastAbility
	return self

func try_activate() -> void:
	if _ability.anim_type == CastAbility.AnimType.Oneshot:
		_ctx.play_oneshot_anim(_ability.anim_trigger)

func execute() -> void:
	if _ability == null:
		return
	
	var node := _ability.scene.instantiate()
	if _ability is CastAbility and node is AbilityEntity:
		_ctx.spawn_node(node)
		node.launch_ability(_ability, _ctx)
	
	_ability = null
