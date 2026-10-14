extends Node3D

@export var replacement: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(name)

func _die() -> void:
	print("Dead")
	var node = replacement.instantiate()
	$"../".add_child(node)
	if node is Node3D:
		var update_pos = func():
			(node as Node3D).global_transform = global_transform
		update_pos.call_deferred()
	queue_free()
