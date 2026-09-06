extends "res://entities/components/save_base.gd"

func do_load(file: FileAccess):
	$".."._move(save.get_position(file))
	$".."._set_disable( bool(file.get_8()) )

func do_save(file: FileAccess):
	save.store_position(file, $"..".position)
	file.store_8($"..".disabled)
