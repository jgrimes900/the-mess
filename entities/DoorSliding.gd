extends AnimatableBody3D

class_name DoorSliding

@export var move_direction: Vector3 = Vector3.UP
@export var move_speed: float = 10.0
@export var lip: float = 0.0
@export var close_time: float = 4.0
@export var start_open_flag: bool = false

@export var sound: AudioStreamPlayer3D
@export var sound_open: AudioStream
@export var sound_close: AudioStream
@export var sound_move: AudioStream
@export var sound_stop: AudioStream
@export var sound_start: AudioStream

signal opened()
signal closed()

signal start_open()
signal start_close()

var state: int = 0
var openness: float = 0.0
var close_timer: float = 0.0
var move_delta_val: float = 0.0

func _ready() -> void:
	if start_open_flag:
		if state == 0:
			state = 2
			openness = lip
			translate_object_local(move_direction * openness)
		elif state == 2:
			state = 1
			openness = 0
			translate_object_local(move_direction * -lip)

func _on_touch(_body_rid, body, _body_shape_index = null, _local_shape_index = null) -> void:
	if body is NodePath:
		body = get_node(body)
		if !body:
			return
	if body.name == "Player" or body is CharacterBody3D:
		_open()

func _force_open():
	if state == 0:
		emit_signal("start_open")
		state = 1
		do_sound()
func _force_close():
	if state == 2:
		emit_signal("start_close")
		state = 3
		do_sound()

func _open():
	_force_open()
	_force_close()

func _physics_process(delta: float) -> void:
	if state == 1:
		move_delta_val = move_speed * delta
		openness += move_delta_val
		
		if openness >= lip:
			translate_object_local(move_direction * (move_delta_val - (openness - lip)))
			openness = lip
			state = 2
			emit_signal("opened")
			do_sound()
			close_timer = 0.0
		else:
			translate_object_local(move_direction * move_delta_val)
	elif state == 2 and close_time >= 0:
		close_timer += delta
		if close_timer >= close_time:
			_force_close()
			close_timer = 0.0
			
	elif state == 3:
		move_delta_val = -move_speed * delta
		openness += move_delta_val
		
		if openness <= 0.0:
			translate_object_local(move_direction * (move_delta_val - openness))
			openness = 0.0
			state = 0
			emit_signal("closed")
			do_sound()
			close_timer = 0.0
		else:
			translate_object_local(move_direction * move_delta_val)


func _on_door_state_true() -> void:
	pass # Replace with function body.

func _lip_to_source_lip(aabb: Vector3) -> void:
	var x_comp = (move_direction.x * move_direction.x) / (aabb.x * aabb.x)
	var y_comp = (move_direction.y * move_direction.y) / (aabb.y * aabb.y)
	var z_comp = (move_direction.z * move_direction.z) / (aabb.z * aabb.z)
	
	lip = (1.0 / sqrt(x_comp + y_comp + z_comp)) - lip

func do_sound(state_temp: int = state):
	if sound:
		sound.stop()
		if sound_stop and state_temp == 2:
			sound.stream = sound_stop
			sound.play()
		elif state_temp == 0:
			if sound_close:
				sound.stream = sound_close
				sound.play()
			elif sound_stop:
				sound.stream = sound_stop
				sound.play()
		elif state_temp == 1:
			if sound_open:
				sound.stream = sound_open
				sound.play()
			elif sound_start:
				sound.stream = sound_start
				sound.play()
		elif state_temp == 3 and sound_start:
			sound.stream = sound_start
			sound.play()
		


func _on_sound_finished() -> void:
	if sound and sound_move and (state == 1 or state == 3):
		sound.stream = sound_move
		sound.play()
