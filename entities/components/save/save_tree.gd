extends Node

func _ready() -> void:
	if $"/root/Node3D".has_node("./tree_data"):
		var do_the_thing = func():
			if $"/root/Node3D/tree_data/save"._is_dead($"../".position): $"../"._die()
		$"/root/Node3D/tree_data/save".connect("loaded", do_the_thing)
	

func _add_hash():
	if $"/root/Node3D".has_node("./tree_data"):
		print("a")
		$"/root/Node3D/tree_data/save"._reg_dead($"../".position)
