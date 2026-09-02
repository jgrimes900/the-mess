extends Node3D

@export var rotation_lag: bool = false
@export var position_lag: bool = false
@export var match_speed: float = 50.0
@export var match_node: Node3D

@export var rotation_offset: Vector3 = global_rotation
@export var position_offset: Vector3 = global_position

@onready var rotation_last: Vector3 = global_rotation
@onready var position_last: Vector3 = global_position

func _physics_process(delta: float) -> void:
	if rotation_lag:
		var q1 = Quaternion.from_euler(rotation_last)
		var q2 = (Quaternion.from_euler(match_node.global_rotation)*Quaternion.from_euler(rotation_offset)).normalized()
		global_rotation = q1.slerp(q2, (delta*match_speed)*q1.angle_to(q2)).get_euler()
		rotation_last = global_rotation
	if position_lag:
		global_position.x = move_toward(position_last.x, match_node.global_position.x+position_offset.x, delta*match_speed)
		global_position.y = move_toward(position_last.y, match_node.global_position.y+position_offset.y, delta*match_speed)
		global_position.z = move_toward(position_last.z, match_node.global_position.z+position_offset.z, delta*match_speed)
		position_last = global_position
