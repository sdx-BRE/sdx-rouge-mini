class_name SkeletonMinionStateConfig extends RefCounted

var attack_cooldown: float
var wait_time: float

func _init(
	p_attack_cooldown: float,
	p_wait_time: float,
) -> void:
	attack_cooldown = p_attack_cooldown
	wait_time = p_wait_time

static func from_minion(minion: SkeletonMinion) -> SkeletonMinionStateConfig:
	return SkeletonMinionStateConfig.new(
		minion.attack_cooldown,
		minion.wait_time,
	)
