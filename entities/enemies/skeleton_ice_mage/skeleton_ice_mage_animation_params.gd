class_name SkeletonIceMageAnimationParams extends RefCounted

var oneshot_hit_strong: StringName
var oneshot_hit_weak: StringName
var oneshot_spawn_air: StringName
var oneshot_spawn_ground: StringName
var loco_blend_position: StringName
var loco_time_scale: StringName
var state_death: StringName

func _init(
	os_hit_strong: StringName,
	os_hit_weak: StringName,
	os_spawn_air: StringName,
	os_spawn_ground: StringName,
	l_blend_position: StringName,
	l_time_scale: StringName,
	s_death: StringName,
) -> void:
	oneshot_hit_strong = os_hit_strong
	oneshot_hit_weak = os_hit_weak
	oneshot_spawn_air = os_spawn_air
	oneshot_spawn_ground = os_spawn_ground
	loco_blend_position = l_blend_position
	loco_time_scale = l_time_scale
	state_death = s_death

static func from_entity(minion: SkeletonIceMage) -> SkeletonIceMageAnimationParams:
	return SkeletonIceMageAnimationParams.new(
		minion.oneshot_hit_strong,
		minion.oneshot_hit_weak,
		minion.oneshot_spawn_air,
		minion.oneshot_spawn_ground,
		minion.path_locomotion_blend,
		minion.path_locomotion_timescale,
		minion.state_death,
	)
