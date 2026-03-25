class_name ThirdPersonCam
extends Marker3D

@export var camera_node: Camera3D

@export var rotation_sensitivity: float = 0.002
@export var distance_sensitivity: float = 0.8

@export var min_angle_x: float = -60.0
@export var max_angle_x: float = -5.0

@export var min_distance: float = 2.0
@export var max_distance: float = 20.0
@export var zoom_speed: float = 5.0

var _scroll: ScrollHandler
var _rotate: RotationHandler

func use_visible_mouse() -> void:
	_rotate.disable_rotation()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func use_captured_mouse() -> void:
	_rotate.enable_rotation()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready():
	_scroll = ScrollHandler.new(
		self,
		min_distance,
		max_distance,
		camera_node.transform.origin.z,
		zoom_speed
	)
	_rotate = RotationHandler.new(
		self,
		rotation_sensitivity,
		rotation.x,
		rotation.y,
		min_angle_x,
		max_angle_x,
		true,
	)
	use_captured_mouse()

func _process(delta: float) -> void:
	_scroll.process(delta)

func handle_input(event):
	if event is InputEventMouseMotion:	
		_rotate.handle(event)
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_scroll.scroll(-1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_scroll.scroll(1)

class RotationHandler:
	var _cam: ThirdPersonCam
	var _rotation_sensitivity: float
	var _rot_x: float
	var _rot_y: float
	var _min_angle_x: float
	var _max_angle_x: float
	var _is_rotation_enabled: bool
	
	func _init(
		cam: ThirdPersonCam,
		rotation_sensitivity: float,
		rot_x: float,
		rot_y: float,
		min_angle_x: float,
		max_angle_x: float,
		rotation_enabled: bool,
	) -> void:
		_cam = cam
		_rotation_sensitivity = rotation_sensitivity
		_rot_x = rot_x
		_rot_y = rot_y
		_min_angle_x = min_angle_x
		_max_angle_x = max_angle_x
		_is_rotation_enabled = rotation_enabled
	
	func handle(event: InputEventMouseMotion) -> void:
		if not _is_rotation_enabled:
			return
		
		_rot_x -= event.relative.y * _rotation_sensitivity
		_rot_x = clamp(_rot_x, deg_to_rad(_min_angle_x), deg_to_rad(_max_angle_x))
		_cam.rotation.x = _rot_x
		
		_rot_y -= event.relative.x * _rotation_sensitivity
		_cam.rotation.y = _rot_y
	
	func enable_rotation() -> void:
		_is_rotation_enabled = true
	
	func disable_rotation() -> void:
		_is_rotation_enabled = false

class ScrollHandler:
	var _cam: ThirdPersonCam
	var _min_distance: float
	var _max_distance: float
	var _target_z: float
	var _zoom_speed: float
	
	func _init(
		cam: ThirdPersonCam,
		min_distance: float,
		max_distance: float,
		cam_z: float,
		zoom_speed: float,
	) -> void:
		_cam = cam
		_min_distance = min_distance
		_max_distance = max_distance
		_target_z = cam_z
		_zoom_speed = zoom_speed
	
	func process(delta: float) -> void:
		var weight = clamp(delta * _zoom_speed, 0, 1)
		_cam.camera_node.transform.origin.z = lerp(
			_cam.camera_node.transform.origin.z,
			_target_z,
			weight
		)
	
	func scroll(value: float) -> void:
		_target_z = clamp(_target_z + value, _min_distance, _max_distance)
