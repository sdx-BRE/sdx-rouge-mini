class_name EnemyBlackboard extends RefCounted

var _attack_cooldown: float

func _init(attack_cooldown: float) -> void:
	_attack_cooldown = attack_cooldown

static func from_data(data: EnemyData) -> EnemyBlackboard:
	return EnemyBlackboard.new(data.attack_cooldown)

func tick(delta: float) -> void:
	_attack_cooldown = max(_attack_cooldown - delta, 0.0)

func can_attack() -> bool:
	return _attack_cooldown <= 0.0

func start_attack_cooldown(duration: float) -> void:
	_attack_cooldown = duration
