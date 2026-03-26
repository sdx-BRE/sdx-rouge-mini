class_name SkeletonMinionStateData extends RefCounted

var walking_speed: float
var running_speed: float
var attack_cooldown: float

func _init(
	p_walking_speed: float,
	p_running_speed: float,
	p_attack_cooldown: float,
) -> void:
	walking_speed = p_walking_speed
	running_speed = p_running_speed
	attack_cooldown = p_attack_cooldown

static func from_minion(minion: SkeletonMinion) -> SkeletonMinionStateData:
	return SkeletonMinionStateData.new(
		minion.data.walking_speed,
		minion.data.running_speed,
		minion.attack_cooldown,
	)
