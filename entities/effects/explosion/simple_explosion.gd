extends Area3D

@onready var debris: GPUParticles3D = $Debris
@onready var smoke: GPUParticles3D = $Smoke
@onready var fire: GPUParticles3D = $Fire
@onready var explosion_sound: AudioStreamPlayer3D = $ExplosionSound

@onready var effects: Array[GPUParticles3D] = [debris, smoke, fire]

var _finished_count: int = 0

func _ready() -> void:
	for effect in effects:
		effect.emitting = true
		effect.finished.connect(_on_particle_finished)
	
	explosion_sound.play()

func _on_particle_finished() -> void:
	_finished_count += 1
	if _finished_count >= effects.size():
		queue_free()
