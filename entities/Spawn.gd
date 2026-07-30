extends Node3D

@export var is_offset: bool = false
@export var is_offset_from_prev_teleport: bool = false
@export var offset: Vector3 = Vector3.ZERO
@export var rot_offset: float = 0
@export var main: bool = true
@export var from_maps: Array = []

signal on_spawn()

func _ready() -> void:
	print(get_node("/root/Player").last_map)
	if ! get_node("/root/Player").spawned:
		if main:
			if !from_maps.has(get_node("/root/Player").last_map):
				spawn()
		elif from_maps.has(get_node("/root/Player").last_map):
			spawn()

func spawn():
	var player = get_node("/root/Player") as CharacterBody3D;
	if is_offset:
		if is_offset_from_prev_teleport:
			player.global_position = global_position + (player.prev_teleport_offset as Vector3).rotated(Vector3.UP, -deg_to_rad(rot_offset))
		player.global_position += offset;
		player.rotate_object_local(Vector3.UP, deg_to_rad(rot_offset))
	else:
		player.global_position = global_position;
	player.spawned = true
	emit_signal("on_spawn")

## Inputs
func Respawn(is_offset_set: bool = false): 
	is_offset = is_offset_set
	spawn();
