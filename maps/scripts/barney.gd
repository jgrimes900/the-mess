extends Node3D


@onready var pos = [
	$stage,
	$dine,
	$pas,
	$lhall,
	$lhallc,
	$ldoor,
	$closit
]

var posi = 0
var ai = 0
var ready_to_kill = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for a in pos:
		a.visible = false
	pos[posi].visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if posi < 0:
		if $"../Controler".Cam_State == 2:
			ready_to_kill = 1
		if $"../Controler".Cam_State == 3 and ready_to_kill == 1:
			$"../Control/JumpScare/barney".visible = true
			$"../Control/JumpScare/TEMP_Timer".start()
			ready_to_kill = 2

func _on_timer_timeout() -> void:
	print("op")
	if randi_range(1,20)<ai:
		pos[posi].visible = false
		match posi:
			0:
				posi = [1,2].pick_random()
			1:
				posi = [2,3].pick_random()
			2:
				posi = [1,3].pick_random()
			3:
				posi = [4,6].pick_random()
			4:
				posi = [5,6].pick_random()
			6:
				posi = [4,5].pick_random()
			5:
				match $"../Controler".DoorLeft_state:
					0:
						posi = 1
					2:
						posi = -1
						$"../Controler"._disable_controls(0)
						print("got you")
		if posi > -1:
			pos[posi].visible = true


func _on_temp_timer_timeout() -> void:
	if ready_to_kill == 2:
		$"../Control/ambiance_1".stop()
		$"../Control/ambiance_2".stop()
		$"../Control/death_sound".play()
		$"../Control/DeathStatic".visible = true
		$"../Control/DeathStatic/Timer".start()
		
