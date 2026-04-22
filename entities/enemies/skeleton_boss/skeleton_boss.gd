class_name SkeletonBoss extends BaseSkeletonEnemy

const MAX_WEAPON_HITBOX_ENABLED_TIME := 0.75

@onready var weapon_hitbox: Area3D = $Pivot/Rig_Medium/Skeleton3D/Skeleton_Warrior_HandslotRight/Weapon_Container/Weapon_2H_Axe/Weapon_Hitbox

func _ready() -> void:
	super()
	weapon_hitbox.area_entered.connect(_on_weapon_hitbox_area_entered)

func start_weapon_hitbox() -> void:
	weapon_hitbox.monitoring = true

func end_weapon_hitbox() -> void:
	weapon_hitbox.monitoring = false

func _on_weapon_hitbox_area_entered(body: Node3D) -> void:
	_ability_system.notify_hit_event(body)
