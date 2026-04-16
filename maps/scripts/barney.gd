extends "res://maps/scripts/fnaf_like_enemy.gd"

enum POSITIONS {STAGE, DINE, PAS, LHALL, LHALLC, LDOOR, CLOSIT}

func _init():
	pos = [
		$stage,
		$dine,
		$pas,
		$lhall,
		$lhallc,
		$ldoor,
		$closit
	]
	JumpScare = $"../Control/JumpScare/barney"

func move():
		match posi:
			POSITIONS.STAGE:
				posi = [POSITIONS.DINE,POSITIONS.PAS].pick_random()
			POSITIONS.DINE:
				posi = [POSITIONS.PAS,POSITIONS.LHALL].pick_random()
			POSITIONS.PAS:
				posi = [POSITIONS.DINE,POSITIONS.LHALL].pick_random()
			POSITIONS.LHALL:
				posi = [POSITIONS.LHALLC,POSITIONS.CLOSIT].pick_random()
			POSITIONS.LHALLC:
				posi = [POSITIONS.CLOSIT,POSITIONS.LDOOR].pick_random()
			POSITIONS.CLOSIT:
				posi = [POSITIONS.LHALL,POSITIONS.LDOOR].pick_random()
			POSITIONS.LDOOR:
				gotyou(SIDES.LEFT,POSITIONS.DINE)
