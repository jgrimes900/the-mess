extends Node3D

@export var is_offset: bool = false
@export var offset: Vector3 = Vector3.ZERO
@export var main: bool = true
@export var from_maps: Array = []

signal on_spawn()

func _ready() -> void:
	print(get_node("/root/Player").last_map)
	if ! get_node("/root/Player").spawned:
		if main:
			spawn()
		else:
			for map in from_maps:
				if get_node("/root/Player").last_map == map:
					spawn()

func spawn():
	var player = get_node("/root/Player") as CharacterBody3D;
	if is_offset:
		player.global_position += offset;
	else:
		player.global_position = global_position;
	player.spawned = true
	emit_signal("on_spawn")

## Inputs
func Respawn(is_offset_set: bool = false): 
	is_offset = is_offset_set
	spawn();
