class_name SkeletonMinionStateConfig extends RefCounted

var attack_cooldown: float

func _init(p_attack_cooldown: float) -> void:
	attack_cooldown = p_attack_cooldown

static func from_minion(minion: SkeletonMinion) -> SkeletonMinionStateConfig:
	return SkeletonMinionStateConfig.new(
		minion.attack_cooldown,
	)
