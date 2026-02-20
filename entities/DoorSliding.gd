extends AnimatableBody3D

@export var move_direction: Vector3 = Vector3.UP
@export var move_speed: float = 10.0
@export var lip: float = 0.0
@export var close_time: float = 4.0

signal opened()
signal closed()

var state: int = 0
var openness: float = 0.0
var close_timer: float = 0.0
var move_delta_val: float = 0.0

func _on_touch(_body_rid, body, _body_shape_index = null, _local_shape_index = null) -> void:
	if body is NodePath:
		body = get_node(body)
		if !body:
			return
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
			emit_signal("opened")
		else:
			translate_object_local(move_direction * move_delta_val)
			1.0
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
			emit_signal("closed")
		else:
			translate_object_local(move_direction * move_delta_val)


func _on_door_state_true() -> void:
	pass # Replace with function body.
