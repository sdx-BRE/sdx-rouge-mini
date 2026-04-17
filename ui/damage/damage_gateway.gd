extends CanvasLayer

signal display_damage(damage: float, position: Vector3)

func emit_display_damage(damage: float, position: Vector3) -> void:
	display_damage.emit(damage, position)
