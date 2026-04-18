@tool
extends BaseAoe

@export var texture_size: int = 512

@export_tool_button("Update Radius", "callable") var update_radius_btn := _update_radius

@onready var hitbox := $Hitbox
@onready var sprite := $Sprite3D
@onready var progess_bar := $SubViewport/TextureProgressBar
@onready var timer := $Timer

func _ready() -> void:
	_update_radius()
	area_entered.connect(_on_area_entered)
	timer.timeout.connect(_trigger_aoe)

func launch_enemy_ability(data: CharacterAbilityDelivery, context: CharacterAbilityExecuteContext) -> void:
	super(data, context)
	_update_radius()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var elapsed: float = _delay - timer.time_left
	var ratio := elapsed / _delay
	var percent := ratio * 100
	
	progess_bar.value = percent

func _on_area_entered(body: Node3D) -> void:
	if body.has_method("take_dmg"):
		body.take_dmg(_damage)

func _trigger_aoe():
	hitbox.disabled = false
	await get_tree().create_timer(0.5).timeout
	
	queue_free()

func _update_radius() -> void:
	if hitbox.shape is CylinderShape3D:
		hitbox.shape.radius = _radius
	
	var base_size: float = texture_size * sprite.pixel_size
	var diameter := _radius * 2
	var sprite_scale := diameter / base_size
	
	sprite.scale = Vector3(sprite_scale, sprite.scale.y, sprite_scale)
