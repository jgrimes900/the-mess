extends Area3D

const SOUND = preload("uid://btlcj7opvssw5")

const KNOWN_MAPS = {
	hl1_c1a0 = "uid://bck1kpbmbaj8n",
	gbj = "uid://oef73g5qqf1y",
	GridMapTest = "uid://bnijdfm8dpeuu"
}

func MapChange(_a,body: Node3D,level: String) -> void:
	if body == get_node("/root/Player"):
		var callable = Callable(DoTheThing);
		callable.call_deferred(level)
		get_node("/root/Player/AudioTele").stream = SOUND
		get_node("/root/Player/AudioTele").play()
	
func DoTheThing(level: String):
	if KNOWN_MAPS[level]:
		level = KNOWN_MAPS[level]
	get_tree().change_scene_to_file(level)
