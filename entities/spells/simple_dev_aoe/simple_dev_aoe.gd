@tool
extends Area3D

@export var delay: float = 3.5
@export var radius: float = 4.0
@export var texture_size: int = 512
@export var dmg: float = 4.0

@export_tool_button("Update Radius", "callable") var update_radius_btn := _update_radius

@onready var hitbox := $Hitbox
@onready var sprite := $Sprite3D
@onready var progess_bar := $SubViewport/TextureProgressBar

var _timer: float = delay

func _ready() -> void:
	_update_radius()
	area_entered.connect(_on_area_entered)

func _on_area_entered(body: Node3D) -> void:
	DbgHelper.tprint("entered: ", body)
	if body.has_method("take_dmg"):
		DbgHelper.tprint("    <-- and takes dmg")
		body.take_dmg(dmg)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	_timer -= delta
	
	var elapsed = delay - _timer
	var ratio = elapsed / delay
	var percent = ratio * 100
	
	progess_bar.value = percent
	if _timer <= 0.0:
		_trigger_aoe()

func _trigger_aoe():
	hitbox.disabled = false
	await get_tree().create_timer(0.5).timeout
	
	queue_free()

func _update_radius() -> void:
	if hitbox.shape is CylinderShape3D:
		hitbox.shape.radius = radius
	
	var base_size = texture_size * sprite.pixel_size
	var diameter = radius * 2
	var sprite_scale = diameter / base_size
	
	sprite.scale = Vector3(sprite_scale, sprite.scale.y, sprite_scale)
