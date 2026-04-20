extends "res://entities/components/save_base.gd"


func do_load(file: FileAccess):
	$"..".coins_collected = save.get_bool_array(file)

func do_save(file: FileAccess):
	save.store_bool_array(file, $"..".coins_collected)
