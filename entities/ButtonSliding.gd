extends "res://entities/DoorSliding.gd"

var can_use = true

func _on_use() -> void:
	_open()
