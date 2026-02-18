@tool
extends "res://entities/Pole.gd"

@export var size: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	height = 4.0*size
	super._ready()
	var sprite = Sprite3D.new();
	var texture = load("res://sm64_tree.png")
	sprite.texture = texture
	sprite.centered = false
	sprite.offset.x = -32
	sprite.pixel_size = 0.03125*2*size
	sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	add_child(sprite)
