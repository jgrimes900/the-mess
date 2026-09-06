extends "res://entities/components/save_base.gd"


func do_load(file: FileAccess):
	if file.get_8() == 1:
		$".."._kill()

func do_save(file: FileAccess):
	if $".." is Residue:
		file.store_8(1)
		$"..".name = $"..".name.substr(1)
	else:
		file.store_8(0)
