class_name AbilityHandlerCast extends AbilityHandler

var _ctx: AbilityContextCast
var _ability: CastAbility

func _init(ctx: AbilityContextCast) -> void:
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
	
	if node is Node3D:
		_ctx.spawn_node(node)
		
		node.global_position = _ctx.get_cast_position()
		node.global_basis = _ctx.get_host_basis()
	
	_ability = null
