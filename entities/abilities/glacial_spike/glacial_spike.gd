extends BaseAoe

const SHADER_PARAM_FADE := ":instance_shader_parameters/FadeAmount"

const ANIMATION_TRACK_PATH_FADE: NodePath = "Spikes/Spike01" + SHADER_PARAM_FADE
const ANIMATION_NAME := &"Init"
const SPIKE_RADIUS := 0.2

@onready var container_spikes := $Spikes
@onready var spike := $Spikes/Spike01
@onready var container_spikes_ground := $Ice
@onready var anim_player := $AnimationPlayer
@onready var hitbox := $Hitbox

var _temp_animations: Array[Dictionary]

func _ready() -> void:
	super()
	get_tree().create_timer(_delay + 30.0).timeout.connect(queue_free)
	anim_player.animation_finished.connect(_cleanup_temp_animations)
	
	_generate_spike_field()
	container_spikes_ground.scale = Vector3(_radius, 1.0, _radius)
	(hitbox.shape as CylinderShape3D).radius = _radius

func _process(_delta: float) -> void:
	pass

func _cleanup_temp_animations(_anim_name: String) -> void:
	var temp_anim = _temp_animations.pop_back()

	while temp_anim:
		var lib: AnimationLibrary = anim_player.get_animation_library(temp_anim.lib_name)
		
		if lib != null:
			lib.remove_animation(temp_anim.anim_name)
		anim_player.remove_animation_library(temp_anim.lib_name)
		
		temp_anim = _temp_animations.pop_back()

func _add_animation_tracks(new_spike: MeshInstance3D, anim: Animation, master_track_idx: int) -> void:
	var spike_path := anim_player.get_parent().get_path_to(new_spike)
	var property_path := str(spike_path) + SHADER_PARAM_FADE as NodePath
	
	var track_idx := anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_idx, property_path)
	
	_copy_tracks(master_track_idx, track_idx, anim)

func _copy_tracks(source_idx: int, target_tdx: int, anim: Animation) -> void:
	for key_idx in anim.track_get_key_count(source_idx):
		var time := anim.track_get_key_time(source_idx, key_idx)
		var value = anim.track_get_key_value(source_idx, key_idx)
		var transition := anim.track_get_key_transition(source_idx, key_idx)
		
		anim.track_insert_key(target_tdx, time, value, transition)

func _generate_spike_field() -> void:
	spike.visible = false
	
	var anim: Animation = anim_player.get_animation(ANIMATION_NAME)
	var anim_duplicate: Animation = anim.duplicate()
	var master_track_idx := anim_duplicate.find_track(ANIMATION_TRACK_PATH_FADE, Animation.TYPE_VALUE)
	
	_spawn_spike(anim_duplicate, master_track_idx, Vector3.ZERO, randf_range(0.3, 0.6))

	var step_size := SPIKE_RADIUS * 2.0
	var ring_count = floor(_radius / step_size)
	
	var target_spacing := step_size * 0.9
	
	for r in range(1, ring_count):
		var current_ring_distance = r * step_size
		var circumference = 2.0 * PI * current_ring_distance
		
		var spikes_in_ring = floor(circumference / target_spacing)
		
		for i in range(spikes_in_ring):
			var angle = i * (TAU / spikes_in_ring)
			
			var jitter_angle := randf_range(-0.1, 0.1)
			var jitter_dist := randf_range(-0.1, 0.1) * step_size
			
			var final_dist = current_ring_distance + jitter_dist
			var final_angle = angle + jitter_angle
			
			var pos := Vector3(
				cos(final_angle) * final_dist,
				0.0,
				sin(final_angle) * final_dist
			)
			_spawn_spike(anim_duplicate, master_track_idx, pos, randf_range(0.5, 1.0))
	
	var unique_anim_name := "DynamicInit_" + str(get_instance_id())
	var unique_lib_name := "DynamicLibrary_" + str(get_instance_id())
	
	var lib := AnimationLibrary.new()
	lib.add_animation(unique_anim_name, anim_duplicate)
	anim_player.add_animation_library(unique_lib_name, lib)
	_temp_animations.append({"anim_name": unique_anim_name, "lib_name": unique_lib_name})
	
	anim_player.play(unique_lib_name + "/" + unique_anim_name)

func _spawn_spike(
	anim: Animation, 
	master_track_idx: int,
	pos: Vector3,
	height: float = 1.0
):
	var spike_mesh := CylinderMesh.new()
	spike_mesh.height = height
	spike_mesh.top_radius = 0.0
	spike_mesh.bottom_radius = SPIKE_RADIUS
	
	var new_spike := MeshInstance3D.new()
	new_spike.mesh = spike_mesh
	
	new_spike.set_surface_override_material(0, spike.get_surface_override_material(0))
	new_spike.set_instance_shader_parameter(&"vertex_frequency", randf_range(-100.0, 100.0))
	
	container_spikes.add_child(new_spike)
	pos.y = height * 0.4
	
	new_spike.position = pos
	new_spike.rotation.y = deg_to_rad(randf_range(-180.0, 180.0))
	new_spike.rotation.x = deg_to_rad(randf_range(-10.0, 10.0))
	new_spike.rotation.z = deg_to_rad(randf_range(-10.0, 10.0))
	
	_add_animation_tracks(new_spike, anim, master_track_idx)
