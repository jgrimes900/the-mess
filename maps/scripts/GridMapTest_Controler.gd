extends GridMap

const PREFAB_DOOR = preload("uid://c22wldk8v3xb2")

const CELL_OFFSET = Vector3i(1, 1, 1)

const CELL_ID_DOOR = 0
const CELL_ID_WALL = 1
const CELL_ID_BUTTON_DOOR = 3

func _ready() -> void:	
	# Replace all the static door tiles with the working prefab counterpart
	for door in get_used_cells_by_item(CELL_ID_DOOR):
		var instance: Node3D = PREFAB_DOOR.instantiate()
		instance.basis = get_cell_item_basis(door)
		print(get_cell_item_basis(door).get_scale())
		instance.position = door * 2 + CELL_OFFSET
		instance.name = "x"+str(door.x)+"y"+str(door.y)+"z"+str(door.z)
		print(instance.name)
		add_child(instance)
		set_cell_item(door, -1)
		print("Replaced door tile")
	for door in get_used_cells_by_item(CELL_ID_BUTTON_DOOR):
		var instance: Node3D = PREFAB_DOOR.instantiate()
		instance.remove_child(instance.get_child(2)) # Remove touch Area3D
		instance.remove_child(instance.get_child(2)) # Remove Health component
		instance.close_time = -1
		instance.basis = get_cell_item_basis(door)
		print(get_cell_item_basis(door).get_scale())
		instance.position = door * 2 + CELL_OFFSET
		instance.name = "x"+str(door.x)+"y"+str(door.y)+"z"+str(door.z)
		print(instance.name)
		add_child(instance)
		set_cell_item(door, -1)
		print("Replaced button door tile")
	
