extends DoorSliding

class_name DoorRotating

@export var reverse: bool = false
@export var stay: bool = false

func _ready() -> void:
	lip = deg_to_rad(lip)
	if reverse:
		state = 2
		openness = lip
	if start_open_flag:
		if state == 0:
			state = 2
			openness = lip
			rotate_object_local(move_direction, move_delta_val + lip)
		elif state == 2:
			state = 1
			openness = 0
			rotate_object_local(move_direction, move_delta_val - lip)
			

func _physics_process(delta: float) -> void:
	if state == 1 and !(stay and reverse):
		move_delta_val = move_speed * delta
		openness += move_delta_val
		if openness >= lip:
			rotate_object_local(move_direction, move_delta_val - (openness - (lip)))
			openness = lip
			state = 2
			emit_signal("opened")
			close_timer = 0.0
		else:
			rotate_object_local(move_direction, move_delta_val)
	elif state == 2 and (close_time >= 0 and !reverse):
		close_timer += delta
		if close_timer >= close_time:
			state = 3
			close_timer = 0.0
			
	elif state == 3 and !(stay and !reverse):
		move_delta_val = -move_speed * delta
		openness += move_delta_val
		if openness <= 0.0:
			rotate_object_local(move_direction, (move_delta_val - openness))
			openness = 0.0
			state = 0
			emit_signal("closed")
			close_timer = 0.0
		else:
			rotate_object_local(move_direction, move_delta_val)
	elif state == 0 and (close_time >= 0 and reverse):
		close_timer += delta
		if close_timer >= close_time:
			state = 1
			close_timer = 0.0
