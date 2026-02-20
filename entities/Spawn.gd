extends Node3D

@export var is_offset: bool = false
@export var offset: Vector3 = Vector3.ZERO

signal on_spawn()

func _ready() -> void:
	spawn()

func spawn():
	if is_offset:
		var player = get_node("/root/Player") as CharacterBody3D;
		player.global_position += offset;
	else:
		var player = get_node("/root/Player") as CharacterBody3D;
		player.global_position = global_position;
	emit_signal("on_spawn")

## Inputs
func Respawn(is_offset_set: bool = false): 
	is_offset = is_offset_set
	spawn();
