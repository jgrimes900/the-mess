extends AnimatableBody3D

@export var move_direction: Vector3 = Vector3.UP
@export var move_speed: float = 10.0
@export var lip: float = 0.0
@export var close_time: float = 4.0

var state: int = 0
var openness: float = 0.0
var close_timer: float = 0.0
var move_delta_val: float = 0.0

func _on_touch(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.name == "Player" or body is CharacterBody3D:
		_open()

func _open():
	if state == 0:
		state = 1
	elif state == 2:
		state = 3

func _physics_process(delta: float) -> void:
	if state == 1:
		move_delta_val = move_speed * delta
		openness += move_delta_val
		
		if openness >= lip:
			translate_object_local(move_direction * (move_delta_val + (openness - lip)))
			openness = lip
			state = 2
		else:
			translate_object_local(move_direction * move_delta_val)
			
	elif state == 2 and close_time > 0:
		close_timer += delta
		if close_timer >= close_time:
			state = 3
			close_timer = 0.0
			
	elif state == 3:
		move_delta_val = -move_speed * delta
		openness += move_delta_val
		
		if openness <= 0.0:
			translate_object_local(move_direction * (move_delta_val + openness))
			openness = 0.0
			state = 0
		else:
			translate_object_local(move_direction * move_delta_val)
