class_name AnimationTreeParameter extends Resource

@export_group("Oneshot")
@export var oneshot_hit_weak := &"parameters/HitWeakOneShot"
@export var oneshot_hit_strong := &"parameters/HitStrongOneShot"
@export var oneshot_spawn_ground := &"parameters/SpawnGroundOneShot"
@export var oneshot_spawn_air := &"parameters/SpawnAirOneShot"

@export_group("Full body state")
@export var playback_full_body := &"parameters/FullBodyState/playback"
@export var locomotion_blend := &"parameters/FullBodyState/Locomotion/Movement/blend_position"
@export var locomotion_timescale := &"parameters/FullBodyState/Locomotion/TimeScale/scale"

@export_group("Animation names")
@export var anim_name_death := &"Skeletons_Death"

@export_group("State names")
@export var state_death := &"Death"
