class_name MageSpellAnimation

var scene: PackedScene
var oneshot_prop: StringName
var cast_point: float

func _init(
	p_scene: PackedScene,
	p_oneshot_prop: StringName,
	p_cast_point: float
) -> void:
	scene = p_scene
	oneshot_prop = p_oneshot_prop
	cast_point = p_cast_point

static func create(
	resource: SpellResource,
	animation: SpellAnimationData,
	player: AnimationPlayer,
) -> MageSpellAnimation:
	var c_point = animation.try_get_call_method_track_time(player)
	if c_point == null:
		c_point = 0.01
	
	return MageSpellAnimation.new(
		resource.scene,
		animation.oneshot_property,
		c_point,
	)
