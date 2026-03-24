class_name MageData extends Resource

@export_group("Base stats")
@export var health := 100.0
@export var mana := 80.0
@export var stamina := 100.0

@export_group("Stat regeneration")
@export var mana_regeneration := 1.618
@export var stamina_regeneration := 3.1415

@export_group("Movement")
@export var max_speed := 5.0
@export var dash_power := 20.0
@export var dash_decay := 8.0
