extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	if file:
		var cont = true
		var id
		while cont:
			id = file.get_16()
			if id:
				match id:
					0xFFFF:
						$"../Inv/TabContainer/Beads/Stars".init()
						cont = false
					2:
						$"../Inv/TabContainer/Beads".set_tab_hidden(0, file.get_8() == 1)
					4:
						$"../Inv/TabContainer/Beads/FNaF Like".unlocked = get_bool_array(file)
					3:
						var coins = get_dictionary_int32(file)
						for key in coins:
							if $"../Inv".coin_counts.has(key):
								$"../Inv".coin_counts[key] = coins[key]
								$"../Inv".recive_currency(null, key, 0)
					1:
						LoadLevel.MapChange2(null,get_node("/root/Player"),get_string(file))
					0x100:
						var pos = get_position(file)
						OnLoad.connect("level_loaded", set_ply_pos.bind(pos))
					5:
						$"../Inv/TabContainer/Beads/Stars".unlocked = get_bool_array(file)
					_:
						print("Unknown save chunk ID : "+str(id))
			else:
				cont = false
		file.close()

func set_ply_pos(pos):
	var set_pos = func():
		$"..".position = pos
		$Timer.start()
	set_pos.call_deferred()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
		file.store_16(4)
		store_bool_array(file,$"../Inv/TabContainer/Beads/FNaF Like".unlocked)
		file.store_16(2)
		file.store_8(int($"../Inv/TabContainer/Beads".is_tab_hidden(0)))
		file.store_16(3)
		store_dictionary_int32(file,$"../Inv".coin_counts)
		file.store_16(1)
		store_string(file, $"..".current_map)
		file.store_16(0x100)
		store_position(file, $"..".position)
		file.store_16(5)
		store_bool_array(file, $"../Inv/TabContainer/Beads/Stars".unlocked)
		file.store_16(0xFFFF)
		file.close()
		print("saved")
		var popup: Control = $"../HUD".popup_asset.instantiate()
		popup.text = "Saved!"
		#popup.sprite = popup_sprites[0]
		$"..".add_child(popup)
	if Input.is_action_just_pressed("delete_save"):
		var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
		file.store_16(0xFFFF)
		file.close()
		print("save deleted")
		var popup: Control = $"../HUD".popup_asset.instantiate()
		popup.text = "Saved Deleted!"
		#popup.sprite = popup_sprites[0]
		$"..".add_child(popup)

func store_position(file: FileAccess,pos: Vector3):
	file.store_float(pos.x)
	file.store_float(pos.y)
	file.store_float(pos.z)

func get_position(file: FileAccess) -> Vector3:
	var vec = Vector3.ZERO
	vec.x = file.get_float()
	vec.y = file.get_float()
	vec.z = file.get_float()
	return vec

func store_bool_array(file: FileAccess, array) -> bool:
	var bytes = ceil(len(array)/8)
	var extra = len(array)%8
	if bytes > 256:
		return false
	var byte: int
	file.store_8(bytes)
	file.store_8(extra)
	for i in range(bytes+1):
		byte = 0
		if i == bytes:
			for j in range(extra):
				byte = byte + (int(array[(i*8) + j]) << j)
		else:
			for j in range(0,7):
				byte = byte + (int(array[(i*8) + j]) << j)
		file.store_8(byte)
	return true
	
func get_bool_array(file: FileAccess) -> Array:
	var bytes = file.get_8()
	var extra = file.get_8()
	var byte: int
	var array = []
	var j
	for i in range(bytes+1):
		j=i*8
		byte = file.get_8()
		if i == bytes:
			for k in range(extra):
				array.append((byte & (0x00000001 << k)) > 0)
		else:
			array.append((byte & 0x00000001) > 0)
			array.append((byte & 0x00000010) > 0)
			array.append((byte & 0x00000100) > 0)
			array.append((byte & 0x00001000) > 0)
			array.append((byte & 0x00010000) > 0)
			array.append((byte & 0x00100000) > 0)
			array.append((byte & 0x01000000) > 0)
			array.append((byte & 0x10000000) > 0)
	return array

func store_string(file: FileAccess, string: String):
	for byte in string.to_utf8_buffer():
		file.store_8(byte)
	file.store_8(0xFF)

func get_string(file) -> String:
	var c2 = true
	var key: PackedByteArray
	var byte
	while c2:
		byte = file.get_8()
		if byte == 0xFF:
			c2 = false
		else:
			key.append(byte)
	return key.get_string_from_utf8()

func store_dictionary_int32(file: FileAccess, dict: Dictionary):
	for key in dict:
		store_string(file, key)
		file.store_32(dict[key])
	file.store_8(0xFF)

func get_dictionary_int32(file: FileAccess):
	var c1 = true
	var key = ""
	var dict = {}
	while c1:
		key = get_string(file)
		if len(key) == 0:
			c1 = false
		else:
			dict[key] = file.get_32()
	return dict


func _on_timer_timeout() -> void:
	OnLoad.level_loaded.disconnect(set_ply_pos)
