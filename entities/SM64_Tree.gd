@tool
extends "res://entities/Pole.gd"

# Climbable tree from Super Mario 64.
# Well... it looks like it, anyways

@export var size: float = 1.0

const SM64_TREE = "uid://c4gk3h8tnsd5w" # Tree sprite graphic

func _ready() -> void:
	height = 4.0*size
	super._ready()
	var sprite = Sprite3D.new();
	var texture = load(SM64_TREE)
	sprite.texture = texture
	sprite.centered = false
	sprite.offset.x = -32
	sprite.pixel_size = 0.03125*2*size
	sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	add_child(sprite)
