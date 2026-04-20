extends Node

@onready var save: SaveNode = get_node("/root/Player/Save")

func _ready() -> void:
	save.connect("saving", _save)
	save.connect("loading", _load)

func do_load(file: FileAccess):
	pass

func _load():
	if save.Map_Chuncks.has(get_node("/root/Player").current_map):
		if save.Map_Chuncks[get_node("/root/Player").current_map].has(str($"/root/Node3D".get_path_to($".."))):
			var file = FileAccess.open("user://temp.dat", FileAccess.WRITE)
			file.store_buffer(save.Map_Chuncks[get_node("/root/Player").current_map][str($"/root/Node3D".get_path_to($".."))])
			file.close()
			file = FileAccess.open("user://temp.dat", FileAccess.READ)
			do_load(file)
			file.close()

func do_save(file: FileAccess):
	pass

func _save():
	var file = FileAccess.open("user://temp.dat", FileAccess.WRITE)
	do_save(file)
	file.close()
	file = FileAccess.open("user://temp.dat", FileAccess.READ)
	if not save.Map_Chuncks.has(get_node("/root/Player").current_map):
		save.Map_Chuncks[get_node("/root/Player").current_map] = {}
	save.Map_Chuncks[get_node("/root/Player").current_map][str($"/root/Node3D".get_path_to($".."))] = file.get_buffer(file.get_length())
	file.close()
