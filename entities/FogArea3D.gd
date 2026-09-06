extends Area3D

class_name FogArea3D

@export var worldenv: WorldEnvironment
@export var fog_color: Color
@export var fog_density: float = 0.2
@export var filter_node: Node3D
@export var do_filter: bool = true

func _ready() -> void:
	if !filter_node: filter_node = get_node("/root/Player/Pivot/camera_collider")
	area_shape_entered.connect(func(_a1, body, _a3, _a4):
		apply_fog(body))
	area_shape_exited.connect(func(_a1, body, _a3, _a4):
		restore_fog(body))

func apply_fog(body: Node3D):
	if do_filter and body == filter_node:
		worldenv.environment.fog_enabled = true
		worldenv.environment.fog_light_color = fog_color
		worldenv.environment.fog_density = fog_density
	
func restore_fog(body: Node3D):
	if do_filter and body == filter_node:
		worldenv.environment.fog_enabled = false
