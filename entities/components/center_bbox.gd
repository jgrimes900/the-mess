@tool
extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _calc():
	scale = Vector3(1,1,1) * 1/get_aabb().size.length()
	position = - ((get_aabb().position + (get_aabb().size/2)) * scale)
