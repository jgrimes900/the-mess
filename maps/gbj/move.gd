extends Node

@onready var ply = $"/root/Player"

func _move(offset: Vector3):
	ply.position += offset
