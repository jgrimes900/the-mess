extends Sprite3D

enum States {NOT_PLACED,PLACED,MOVING}
var state = States.NOT_PLACED
var move_to: Vector3i
var direction_to_go: Vector3
var speed: float = 0.1
var move_to_f: Vector3
var last_dir = 0x0001

@export var Map: Node3D

var Directions = [0x1000, 0x0100, 0x0010, 0x0001]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _place(start: Vector3i):
	position.x = start.x*2+1
	position.z = start.z*2+1
	move_to = start
	move_to_f = position
	state = States.PLACED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		States.PLACED:
			if not Map.dirs.has(move_to):
				print("nope")
				state = States.NOT_PLACED
				_place(Map.dirs_keys.pick_random())
			var dirs = Map.dirs[move_to] #0xNESW (-Z, +X, +Z, -X)
			Directions.shuffle()
			Directions.pop_at(Directions.find(last_dir))
			Directions.push_back(last_dir) 
			var temp
			var att = 0
			for direction in Directions:
				att += 1
				temp = dirs & direction
				if temp:
					match direction:
						0x1000:
							move_to.z -= 1
							move_to_f.z -= 2
							direction_to_go = Vector3.FORWARD
							last_dir = 0x0010
						0x0100:
							move_to.x += 1
							move_to_f.x += 2
							direction_to_go = Vector3.RIGHT
							last_dir = 0x0001
						0x0010:
							move_to.z += 1
							move_to_f.z += 2
							direction_to_go = Vector3.BACK
							last_dir = 0x1000
						0x0001:
							move_to.x -= 1
							move_to_f.x -= 2
							direction_to_go = Vector3.LEFT
							last_dir = 0x0100
					state = States.MOVING
					return
			# Got stuck
			state = States.NOT_PLACED
			_place(Map.dirs_keys.pick_random())
		States.MOVING:
			position += direction_to_go * speed
			if position.distance_to(move_to_f) <= speed:
				position = move_to_f
				state = States.PLACED
