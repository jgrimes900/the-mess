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
@onready var CamStaticSprite: AnimatedSprite2D = $"../Control/CamStatic"
@onready var CamCamSVC: SubViewportContainer = $"../Control/CamCam"

@onready var player: CharacterBody3D = get_node("/root/Player")

# 0: Closed
# 1: Transitioning
# 2: Open
var DoorLeft_state = 0
var DoorRight_state = 0
var Cam_State = 0
var CamView = "none"

var ldisable = false
var rdisable = false

var LightState = 0

var time = 0

var night = 1

# 0: GMan		(Freddy)
# 1: Barney		(Bonnie)
# 2: Scientist	(Chica)
# 3: Grunt		(Foxy)
var ais = [
	[0,0,20,0],
	[0,3,2,2],
	[0,5,5,5],
	[2,7,6,8],
	[4,8,8,12],
	[6,11,10,16],
	[20,20,20,20]
]


@onready var cams = {
	"1A"=$"../Control/CamCam/SubViewport/LHallC",
	"2A"=$"../Control/CamCam/SubViewport/RHallC",
	"1B"=$"../Control/CamCam/SubViewport/LHall",
	"2B"=$"../Control/CamCam/SubViewport/RHall",
	"3A"=$"../Control/CamCam/SubViewport/Closit",
	"4A"=$"../Control/CamCam/SubViewport/Room",
	"4B"=$"../Control/CamCam/SubViewport/Stage",
	"5A"=$"../Control/CamCam/SubViewport/Maint",
	"6A"=$"../Control/CamCam/SubViewport/Bath",
	"7A"=$"../Control/CamCam/SubViewport/Bath" #Dummy
}


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
	player.get_node("Pivot/glock/SVC").visible = false
	player.get_node("HUD").visible = false
	player.get_node("Pivot/glock")._set_control(false)
	emit_signal("DoorLeft")
	emit_signal("DoorRight")
#	get_node("/root").move_child($"..", 0)
	player.get_node("Inv")._unlock_beads(0)
	player.get_node("panel_fuck").visible = false
	player.get_node("Control").retrun_code = _return_a
	for n in player.get_node("Inv/TabContainer/Beads/FNaF Like").unlocked:
		if n:
			night += 1
	_reset()
	
func _restet_a():
	if Cam_State == 2:
		_on_cam_button_mouse_entered()
	LightLeft.visible = true
	LightRight.visible = true
	LightState = 0

func _reset():
	if night > 7:
		get_node("/root/Player/Control").open = true
		get_node("/root/Player/Control")._gui_input_return()
	else:
		init_char($"../Gman", 0)
		init_char($"../Barney", 1)
		init_char($"../Scientist", 2)
		init_char($"../Grunt", 3)
		
		if DoorLeft_state == 0:
			emit_signal("DoorLeft")
		if DoorRight_state == 0:
			emit_signal("DoorRight")
		$"../Control/ambiance_1".play()
		$"../Control/ambiance_2".play()
		$"../Control/HUD/Time".text = "12 A.M."
		$"../Hour".start()

func init_char(char, id):
	char.posi = 0
	char.ai = ais[night-1][id]
	char._ready()

func _return_a():
	print("squid")
	player.get_node("Control")._un_2d()
	player.get_node("Pivot/glock/SVC").visible = true
	player.get_node("HUD").visible = true
	player.get_node("Pivot/glock")._set_control(true)
	player.get_node("panel_fuck").visible = true

func do_disabled():
	$"../Control/locked_sound".play()

func _on_left_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("gui_left_click") && Cam_State == 0:
		if ldisable:
			do_disabled()
			return
		emit_signal("DoorLeft")
		DoorLeft_state = 1


func _on_right_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("gui_left_click") && Cam_State == 0:
		if rdisable:
			do_disabled()
			return
		emit_signal("DoorRight")
		DoorRight_state = 1


func _on_left_light_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("gui_left_click") && Cam_State == 0:
		if ldisable:
			do_disabled()
			return
		LightLeft.visible = true
		if LightState == 2:
			LightRight.visible = true
			LightState = 1
		elif LightState == 1:
			LightState = 0
		else:
			LightState = 1


func _on_right_light_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("gui_left_click") && Cam_State == 0:
		if rdisable:
			do_disabled()
			return
		LightRight.visible = true
		if LightState == 1:
			LightLeft.visible = true
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
		CamSprite.visible = true
		CamStaticSprite.visible = false
		CamCamSVC.visible = false
		CamSprite.play("close")
		CamCloseSound.play()
		CamOpenSound.stop()
		$"../Control/SubViewportContainer".visible = true
	LightLeft.visible = true
	LightRight.visible = true
	LightState = 0


func _on_cam_flip_animation_finished() -> void:
	if Cam_State == 1:
		Cam_State = 2
		CamSprite.visible = false
		CamStaticSprite.visible = true
		CamCamSVC.visible = true
		$"../Control/SubViewportContainer".visible = false
	else:
		Cam_State = 0
		
func _on_cam_button_input_event(event: InputEvent, cam: String):
	if Input.is_action_just_pressed("gui_left_click") && Cam_State == 2  && CamView != cam:
		if cams[cam]:
			if cam != "7A":
				$"../Control/CamCam/SubViewport/Camera".position = cams[cam].position
				$"../Control/CamCam/SubViewport/Camera".rotation = cams[cam].rotation
				$"../Control/CamStatic/ColorRect".visible = false
			else:
				$"../Control/CamStatic/ColorRect".visible = true
			CamView = cam
			$"../Control/cam_change_sound".play()

func _disable_controls(which: int):
	match which:
		0:
			ldisable = true
			if LightState == 1:
				LightLeft.visible = true
				LightState = 0
		1:
			rdisable = true
			if LightState == 2:
				LightRight.visible = true
				LightState = 0


func _on_hour_timeout() -> void:
	time += 1
	if time == 6:
		$"../Control2".visible = true
		$"../Control2"._start()
		$"../Hour".stop()
		time = 0
	elif time == 2:
		$"../Barney".ai += 1
	elif time == 3:
		$"../Barney".ai += 1
		$"../Scientist".ai += 1
		$"../Grunt".ai += 1
	elif time == 4:
		$"../Barney".ai += 1
		$"../Scientist".ai += 1
		$"../Grunt".ai += 1
	$"../Control/HUD/Time".text = str(time)+" A.M. "
