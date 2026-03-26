class_name SkeletonMinionStateData extends RefCounted

var walking_speed: float
var running_speed: float
var wait_time: float
var attack_cooldown: float

func _init(
	p_walking_speed: float,
	p_running_speed: float,
	p_wait_time: float,
	p_attack_cooldown: float,
) -> void:
	walking_speed = p_walking_speed
	running_speed = p_running_speed
	wait_time = p_wait_time
	attack_cooldown = p_attack_cooldown

static func from_minion(minion: SkeletonMinion) -> SkeletonMinionStateData:
	return SkeletonMinionStateData.new(
		minion.data.walking_speed,
		minion.data.running_speed,
		minion.wait_time,
		minion.attack_cooldown,
	)
