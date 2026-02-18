extends Area3D

func MapChange(_a,_body: Node3D,level: String) -> void:
	var callable = Callable(DoTheThing);
	callable.call_deferred(level)
	(get_node("/root/Player/AudioTele") as AudioStreamPlayer3D).play()
	
func DoTheThing(level: String):
	get_tree().change_scene_to_file("res://"+level)
