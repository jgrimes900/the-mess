extends "res://entities/AreaHurt3D.gd"

# Specialized version of AreaHurt3D, made for Starkron Bug.

@export var has_target: bool = false

const bug_script_path = "res://entities/starkron/bug.gd"

func _ready() -> void:
		body_shape_entered.connect(func(_a1, body, _a3, _a4):
			if body.get_script().get_path() != bug_script_path:
				bodys_inside.append(body))
		body_shape_exited.connect(func(_a1, body, _a3, _a4):
			if body.get_script().get_path() != bug_script_path:
				bodys_inside.erase(body))

func _physics_process(delta: float) -> void:
	pass

func _process(delta: float) -> void:
	has_target = !bodys_inside.is_empty()

func _attack():
	_calc_damage(1)
	for body in bodys_inside:
		_damage(body)
