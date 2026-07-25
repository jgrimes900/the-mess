extends Node3D

signal state_true()
signal state_false()

@export var state = false

func trigger(...args):
	if state:
		emit_signal.callv(["state_true"] + args)
	else:
		emit_signal.callv(["state_false"] + args)

func _set_state(s):
	state = s
