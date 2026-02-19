extends Node3D

func _ready() -> void:
	spawn()

func spawn():
	var player = get_node("/root/Player") as CharacterBody3D;
	player.global_position = global_position;

## Inputs
func Respawn(): 
	spawn();
