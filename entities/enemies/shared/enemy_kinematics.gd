class_name EnemyKinematics extends RefCounted

var _host: CharacterBody3D

func _init(
	host: CharacterBody3D,
) -> void:
	_host = host

func move_and_slide() -> void:
	_host.move_and_slide()

func handle_gravity(delta: float) -> void:
	if not _host.is_on_floor():
		_host.velocity += _host.get_gravity() * delta
