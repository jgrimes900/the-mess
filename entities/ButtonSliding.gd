extends DoorSliding

class_name ButtonSliding

var can_use = true

func _on_use() -> bool:
	if can_use:
		if state == 0:
			_open()
			print("press")
			return true
	return false
