extends Node3D

@export var persitent = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OnLoad.emit_signal("level_loaded")
	if persitent:
		$"/root/Player/Save".emit_signal("loading")
