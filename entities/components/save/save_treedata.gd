extends "res://entities/components/save_base.gd"

var tree_hash: Array[int] = []
signal loaded

func _reg_dead(pos: Vector3):
	if tree_hash.has(hash(pos)): return
	tree_hash.append(hash(pos))

func _is_dead(pos: Vector3) -> bool:
	if tree_hash.has(hash(pos)): return true
	return false

func do_load(file: FileAccess):
	tree_hash.clear()
	var len_a = file.get_32()
	for i in range(len_a):
		tree_hash.append(file.get_32())
	loaded.emit()
	print(len(tree_hash))
	print(len_a)

func do_save(file: FileAccess):
	print("Saving Tree Hash")
	file.store_32(tree_hash.size())
	for i in range(tree_hash.size()):
		file.store_32(tree_hash[i])
