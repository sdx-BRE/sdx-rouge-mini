class_name MageSpellAnimation extends MageAbilityAnimation

var scene: PackedScene
var cast_point: float

func _init(
	p_trigger: StringName,
	p_scene: PackedScene,
	p_cast_point: float
) -> void:
	super(p_trigger)
	scene = p_scene
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
		animation.anim_trigger,
		resource.scene,
		c_point,
	)
