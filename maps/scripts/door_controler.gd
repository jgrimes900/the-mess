extends Node

signal DoorLeft()
signal DoorRight()

@onready var LightLeft: Node3D = $"../LeftLightBlock"
@onready var LightRight: Node3D = $"../RightLightBlock"
@onready var LightSound: AudioStreamPlayer2D = $"../Control/light_sound"
@onready var DoorSound: AudioStreamPlayer2D = $"../Control/door_sound"

@onready var CamSprite: AnimatedSprite2D = $"../Control/CamFlip"
@onready var CamOpenSound: AudioStreamPlayer2D = $"../Control/camFlip_open_sound"
@onready var CamCloseSound: AudioStreamPlayer2D = $"../Control/camFlip_close_sound"

@onready var player: CharacterBody3D = get_node("/root/Player")

# 0: Closed
# 1: Transitioning
# 2: Open
var DoorLeft_state = 0
var DoorRight_state = 0
var Cam_State = 0

var LightState = 0


func _process(delta: float) -> void:
	if LightState != 0:
		var flicker = randi_range(0,10)
		if flicker == 0:
			LightSound.playing = false
			if LightState == 1:
				LightLeft.visible = true
			else:
				LightRight.visible = true
		elif !LightSound.playing:
			LightSound.playing = true
			if LightState == 1:
				LightLeft.visible = false
			else:
				LightRight.visible = false
	else:
		LightSound.playing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.get_node("Control")._2d_ify()
	emit_signal("DoorLeft")
	emit_signal("DoorRight")


func _on_left_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("gui_left_click") && Cam_State == 0:
		emit_signal("DoorLeft")
		DoorLeft_state = 1


func _on_right_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("gui_left_click") && Cam_State == 0:
		emit_signal("DoorRight")
		DoorRight_state = 1


func _on_left_light_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("gui_left_click") && Cam_State == 0:
		LightLeft.visible = true
		if LightState == 2:
			LightRight.visible = false
			LightState = 1
		elif LightState == 1:
			LightState = 0
		else:
			LightState = 1


func _on_right_light_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_pressed("gui_left_click") && Cam_State == 0:
		LightRight.visible = true
		if LightState == 1:
			LightLeft.visible = false
			LightState = 2
		elif LightState == 2:
			LightState = 0
		else:
			LightState = 2


func _set_right_door_state(state: int) -> void:
	DoorRight_state = state
	
func _set_left_door_state(state: int) -> void:
	DoorLeft_state = state


func _on_cam_button_mouse_entered() -> void:
	if Cam_State == 0:
		Cam_State = 1
		CamSprite.play("open")
		CamOpenSound.play()
		CamCloseSound.stop()
	if Cam_State == 2:
		Cam_State = 3
		CamSprite.play("close")
		CamCloseSound.play()
		CamOpenSound.stop()
	LightLeft.visible = true
	LightRight.visible = true
	LightState = 0


func _on_cam_flip_animation_finished() -> void:
	if Cam_State == 1:
		Cam_State = 2
	else:
		Cam_State = 0
