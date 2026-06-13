extends GridMap

# West and East are swaped in cell names, because I'm dumb
enum CELLS {NW,N_,_W,__,_WExit}

var dirs = {}
var dirs_keys = []

func _ready() -> void:
	var dirs_temp
	var cell_mod:Vector3i
	for cell:Vector3i in get_used_cells():
		dirs_temp = 0x1111	#0xNESW (-Z, +X, +Z, -X)
		cell_mod = cell
		match get_cell_item(cell):
			CELLS.NW:
				dirs_temp = dirs_temp & 0x0011
			CELLS.N_:
				dirs_temp = dirs_temp & 0x0111
			CELLS._W:
				dirs_temp = dirs_temp & 0x1011
			CELLS._WExit:
				dirs_temp = dirs_temp & 0x1011
		cell_mod.x -= 1
		match get_cell_item(cell_mod):
			CELLS.NW:
				dirs_temp = dirs_temp & 0x1110
			CELLS._W:
				dirs_temp = dirs_temp & 0x1110
			CELLS._WExit:
				dirs_temp = dirs_temp & 0x1110
		cell_mod.x += 1
		cell_mod.z += 1
		match get_cell_item(cell_mod):
			CELLS.NW:
				dirs_temp = dirs_temp & 0x1101
			CELLS.N_:
				dirs_temp = dirs_temp & 0x1101
		dirs[cell] = dirs_temp
		dirs_keys.append(cell)
	
	$"../Rat"._place(dirs_keys.pick_random())
	$"../Gravity_Flipper".position = _hall_corner()*2 as Vector3
	$"../Gravity_Flipper".position.x += 1
	$"../Gravity_Flipper".position.z += 1
	$"../Gravity_Flipper".position.y += 1
#	$"../c1a0 Teleport Trigger".position = _corner()*2 as Vector3
#	$"../c1a0 Teleport Trigger".position.x += 1
#	$"../c1a0 Teleport Trigger".position.z += 1
#	$"../c1a0 Teleport Trigger".position.y += 1
	
func _hall_corner() -> Vector3i:
	var dirs_keys_shuff = dirs_keys
	dirs_keys_shuff.shuffle()
	for key in dirs_keys_shuff:
		match dirs[key]:
			0x1010:
				return key
			0x0101:
				return key
			0x1000:
				return key
			0x0100:
				return key
			0x0010:
				return key
			0x0001:
				return key
	return Vector3i.ZERO
	
func _corner() -> Vector3i:
	var dirs_keys_shuff = dirs_keys
	dirs_keys_shuff.shuffle()
	for key in dirs_keys_shuff:
		match dirs[key]:
			0x1000:
				return key
			0x0100:
				return key
			0x0010:
				return key
			0x0001:
				return key
	return Vector3i.ZERO
