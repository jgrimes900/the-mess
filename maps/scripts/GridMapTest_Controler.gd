extends GridMap

const PREFAB_DOOR = preload("uid://c22wldk8v3xb2")

const CELL_OFFSET = Vector3i(1, 1, 1)

const CELL_ID_DOOR = 0
const CELL_ID_WALL = 1

func _ready() -> void:	
	# Replace all the static door tiles with the working prefab counterpart
	for door in get_used_cells_by_item(CELL_ID_DOOR):
		var instance: Node3D = PREFAB_DOOR.instantiate()
		instance.basis = get_cell_item_basis(door)
		print(get_cell_item_basis(door).get_scale())
		instance.position = door * 2 + CELL_OFFSET
		add_child(instance)
		set_cell_item(door, -1)
		print("Replaced door tile")
