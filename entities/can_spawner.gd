extends Node3D

var can_asset: Resource = preload("res://prefabs/hl1/can.tscn")
var can: hl1_can

@export var stock: int = -1

func _spawn():
	if stock != 0:
		if !is_instance_valid(can):
			can = can_asset.instantiate()
			add_child(can)
			can.position = Vector3.ZERO
			stock -= 1
