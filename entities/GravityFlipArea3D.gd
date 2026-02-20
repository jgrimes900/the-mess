extends Area3D

@export var direction: Vector3 = Vector3(0, 0, 180)

var flipped = false
@onready var player = get_node("/root/Player")
@onready var aniplay = get_node("../AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aniplay.play("GravityFlipper/anim_Gravity_Flipper_Rotate")
	connect("body_shape_entered", func(_a, body, _c, _d):
		if body == player:
			if flipped:
				player.rotation_mod = Vector3.ZERO
				player.rotate_ply(player.alive_rotation)
				flipped = false
			else:
				player.rotation_mod = direction
				player.rotate_ply(player.alive_rotation)
				flipped = true
		print(flipped))


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	aniplay.play("GravityFlipper/anim_Gravity_Flipper_Rotate")
