class_name MCharacterAbilityWindup extends Resource

enum Type {
	Oneshot,
	Travel,
}

@export var type: Type = Type.Oneshot
@export var anim_trigger: StringName = &""
@export var anim_end: StringName = &"" # <-- das ist wichtig für channeled/charged, bzw wenn travel gesetzt wird. in den moment wird die scene gespawned via execution (habs zu effekt mittlerweile umbenannt) und dann "zurück getraveled"
@export var anim_name: StringName = &""
