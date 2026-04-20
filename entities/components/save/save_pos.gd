extends "res://entities/components/save_base.gd"

func do_load(file: FileAccess):
	$"..".position = save.get_position(file)

func do_save(file: FileAccess):
	save.store_position(file, $"..".position)
