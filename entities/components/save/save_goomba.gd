extends "res://entities/components/save_base.gd"


func do_load(file: FileAccess):
	if file.get_8() == 1:
		$".."._kill(false)
	else:
		$"..".position = save.get_position(file)
		$"..".rotation = save.get_position(file)
		$"../Health".health = float(file.get_8())
		$"..".target_rot = file.get_float()
		$"..".target_velocity = save.get_position(file)
	
func do_save(file: FileAccess):
	if $".." is Residue:
		file.store_8(1)
		$"..".name = $"..".name.substr(1)
		print($"..".name)
	else:
		file.store_8(0)
		save.store_position(file, $"..".position)
		save.store_position(file, $"..".rotation)
		file.store_8(int($"../Health".health))
		file.store_float($"..".target_rot)
		save.store_position(file, $"..".target_velocity)
