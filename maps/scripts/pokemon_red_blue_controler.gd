extends Node2D

@onready var ply: Player = $"/root/Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ply.ply_mode = "pkmn_rb"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
