class_name MageData extends Resource

@export_group("Base stats")
@export var health := 100.0
@export var mana := 80.0
@export var stamina := 100.0

@export_group("Stat regeneration")
@export var mana_regeneration := 1.618
@export var stamina_regeneration := 3.1415

@export_group("Movement")
@export var speed_normal := 5.0
@export var speed_sprinting := 5.0
@export var dash_power := 20.0
@export var dash_decay := 8.0

@export_group("Jump")
@export var jump_height := 5.0
@export var time_to_peak := 0.35
@export var time_to_descent := 0.25
@export var apex_threshold := 6.0
@export var apex_gravity_multiplier := 1.0
@export var coyote_time := 0.1 # usually between 0.08 – 0.15 second
@export var jump_buffer_time := 0.15
