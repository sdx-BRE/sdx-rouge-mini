class_name EnemyMovementConfig extends Resource

@export var walking_speed: float = 3.5
@export var running_speed: float = 7.5
@export var look_at_weight: float = 10.0

static func from_enemy_data(data: EnemyData) -> EnemyMovementConfig:
	var config := EnemyMovementConfig.new()
	
	config.walking_speed = data.walking_speed
	config.running_speed = data.running_speed
	config.look_at_weight = data.look_at_weight
	
	return config
