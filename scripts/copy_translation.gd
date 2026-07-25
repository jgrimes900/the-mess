extends Camera3D

@export var to_copy: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_transform = to_copy.global_transform
