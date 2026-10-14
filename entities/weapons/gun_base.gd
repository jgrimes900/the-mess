extends Node3D

class_name GunBase

var player_dead = false
var in_control: bool = true
var active: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active and !player_dead and in_control:
		_process_next(delta)
	
func _process_next(delta: float) -> void:
	pass
	
func _select(a:bool):
	if a:
		active = true
		visible = true
		select_setup()
	else:
		active = false
		visible = false

func select_setup():
	pass

func _set_player_dead(a: bool) -> void:
	visible = !a
	player_dead = a

func _set_control(a: bool):
	in_control = a
