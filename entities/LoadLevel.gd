extends Area3D

const SOUND = preload("uid://btlcj7opvssw5")

const KNOWN_MAPS = {
	hl1_c1a0 = "uid://bck1kpbmbaj8n",
	gbj = "uid://oef73g5qqf1y",
	GridMapTest = "uid://bnijdfm8dpeuu",
	WinMap = "uid://etjjb3ij7ot4",
	StarkronDemo1 = "uid://xwm1wyqw5vv3"
}

@export var LevelDef: String

func MapChange(_a = null,body: Node3D = get_node("/root/Player"),level: String = LevelDef) -> void:
	if body == get_node("/root/Player"):
		var callable = Callable(DoTheThing);
		callable.call_deferred(level)
		get_node("/root/Player/AudioTele").stream = SOUND
		get_node("/root/Player/AudioTele").play()
	
func MapChange2(_a = null,body: Node3D = get_node("/root/Player"),level: String = LevelDef) -> void:
	if body == get_node("/root/Player"):
		var callable = Callable(DoTheThing);
		callable.call_deferred(level)
		
func DoTheThing(level: String):
	if KNOWN_MAPS.has(level): # Load map UID if key is used, otherwise assume 'level' is a path or UID
		level = KNOWN_MAPS[level]
	get_tree().change_scene_to_file(level)
