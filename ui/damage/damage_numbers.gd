extends CanvasLayer

@export var label_scene: PackedScene
@export var camera: Camera3D

@onready var container := $Control

var _camera: Camera3D

func _ready() -> void:
	if _setup_camera3d():
		DamageGateway.display_damage.connect(show_damage)

func show_damage(damage: float, position: Vector3) -> void:
	var label_node := _create_label()
	$Control.add_child(label_node)
	label_node.text = str(damage).pad_decimals(2)
	
	var offset_3d := Vector3(randf_range(-0.5, 0.5), randf_range(1.0, 2.0), randf_range(-0.5, 0.5))
	var position_2d := _camera.unproject_position(position + offset_3d)
	var offset_2d := Vector2(randf_range(-20, 20), randf_range(-20, 20))
	label_node.global_position = position_2d + offset_2d
	
	var tween := create_tween().set_parallel(true)
	tween.tween_property(label_node, "position:y", label_node.position.y - 50.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label_node, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(func(): _on_tween_cb(label_node))

func _on_tween_cb(label: Label) -> void:
	print("tween cb")
	label.queue_free()

func _create_label() -> DamageLabel:
	if label_scene == null:
		return DamageLabel.new()
	
	var label := label_scene.instantiate()
	if not label is DamageLabel:
		push_error("[DamageNumbers._create_label()]: label_scene MUST be DamageLabel scene!")
		return DamageLabel.new()
	
	return label

func _setup_camera3d() -> bool:
	if camera != null:
		_camera = camera
		return true
	
	var err_prefix := "[DamageNumbers._setup_camera3d]"
	
	var viewport := get_viewport()
	if viewport == null:
		push_error("%s: get_viewport() - viewport not found" % err_prefix)
		return false
	
	var cam := viewport.get_camera_3d()
	if cam == null:
		push_error("%s: viewport.get_camera_3d() - camera3d not found" % err_prefix)
		return false
	
	_camera = cam
	return true
