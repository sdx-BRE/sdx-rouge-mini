extends AbilityEntity

@onready var effect1 := $Effect1
@onready var effect2 := $Effect2
@onready var effect3 := $Effect3

@onready var effects: Array[GPUParticles3D] = [effect1, effect2, effect3]

var _finished_count: int = 0

func _ready() -> void:
	print("log ready ")
	for effect in effects:
		effect.emitting = true
		effect.finished.connect(_on_particle_finished)

func _on_particle_finished() -> void:
	_finished_count += 1
	if _finished_count >= effects.size():
		queue_free()
