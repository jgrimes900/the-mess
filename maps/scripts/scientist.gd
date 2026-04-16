extends "res://maps/scripts/fnaf_like_enemy.gd"

enum POSITIONS {STAGE, DINE, BATH, RHALL, RHALLC, RDOOR, KITCHEN}

func _init():
	pos = [
		$stage,
		$dine,
		$bath,
		$rhall,
		$rhallc,
		$rdoor,
		$kitchen
	]
	JumpScare = $"../Control/JumpScare/sci"

func move():
		match posi:
			POSITIONS.STAGE:
				posi = POSITIONS.DINE
			POSITIONS.DINE:
				posi = [POSITIONS.BATH,POSITIONS.KITCHEN].pick_random()
			POSITIONS.BATH:
				posi = [POSITIONS.DINE,POSITIONS.KITCHEN].pick_random()
			POSITIONS.RHALL:
				posi = [POSITIONS.DINE,POSITIONS.RHALLC].pick_random()
			POSITIONS.RHALLC:
				posi = [POSITIONS.RHALL,POSITIONS.RDOOR].pick_random()
			POSITIONS.KITCHEN:
				posi = [POSITIONS.DINE,POSITIONS.RHALL].pick_random()
			POSITIONS.RDOOR:
				gotyou(SIDES.RIGHT,POSITIONS.RHALL)

func do_js():
	$"../Control/JumpScare/sci".visible = true
	$"../Control/JumpScare/sci/stage".visible = true
	$"../Control/JumpScare/sci/AnimationPlayer".play("sci_js")
