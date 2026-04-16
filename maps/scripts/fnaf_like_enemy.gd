extends Node3D

enum SIDES {LEFT, RIGHT}

var pos = []
var JumpScare: Control

var posi = 0
var ai = 0
var ready_to_kill = 0

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init()
	for a in pos:
		a.visible = false
	pos[posi].visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if posi < 0:
		if $"../Controler".Cam_State == 2:
			ready_to_kill = 1
		if $"../Controler".Cam_State == 3 and ready_to_kill == 1:
			do_js()
			ready_to_kill = 2

func do_js():
	JumpScare.visible = true
	$"../Control/JumpScare/TEMP_Timer".start()

func _on_timer_timeout() -> void:
	if randi_range(1,20)<ai:
		pos[posi].visible = false
		move()
		if posi > -1:
			pos[posi].visible = true

func move():
	pass

func gotyou(side: SIDES, goback: int):
	var door
	match side:
		SIDES.LEFT:
			door = $"../Controler".DoorLeft_state
		SIDES.RIGHT:
			door = $"../Controler".DoorRight_state
	match door:
		0:
			posi = goback
		2:
			posi = -1
			$"../Controler"._disable_controls(side)
			print("got you")

func _on_temp_timer_timeout() -> void:
	if ready_to_kill == 2:
		$"../Control/ambiance_1".stop()
		$"../Control/ambiance_2".stop()
		$"../Control/death_sound".play()
		$"../Control/DeathStatic".visible = true
		$"../Control/DeathStatic/Timer".start()
		
