class_name EnemyData extends Resource

@export_group("Stats")
@export var max_health: float = 100.0
@export var max_mana: float = 0.0
@export var max_stamina: float = 50.0

@export_group("Movement")
@export var walking_speed: float = 2.5
@export var running_speed: float = 5.0
@export var look_at_weight: float = 10.0

@export_group("Attack")
@export var attack_cooldown: float = 1.5
@export var attack_range: float = 1.5

@export_group("Miscellaneous")
@export var wait_time: float = 2.5
@export var fov_angle: float = 70.0
