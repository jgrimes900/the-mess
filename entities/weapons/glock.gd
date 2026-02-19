extends Node3D

# The glock / 9mm Pistol from Half-Life 1

# Not accurate to the original thing.
# Honestly, this is here because I had the model on-hand
# Same thing with C1A0

@export var has_silencer: bool = false

@onready var aniplay: AnimationPlayer = $AnimationPlayer
@onready var gun: RayCast3D = $Gun
@onready var silencer: MeshInstance3D = $"SVC/SubViewport/v_9mmhandgun_qc_skeleton/Skeleton3D/glock_reference(silencer)"
@onready var SVC: SubViewportContainer = $SVC

var player_dead = false
var in_control: bool = false

func _ready() -> void:
	silencer.visible = has_silencer
	_idle_animation()

# TODO: Add sound, ammo, silencer, missing animations, and make the player have to pick it up first
func _process(delta: float) -> void:
	if Input.is_action_pressed("fire_left") and !player_dead and in_control:
		gun._fire()
		aniplay.play("v_9mmhandgun_animation_lib/shoot")

func _idle_animation():
	aniplay.play("v_9mmhandgun_animation_lib/idle"+str(randi_range(1,3)))


func _player_dead() -> void:
	SVC.visible = false
	player_dead = true
	
func _player_undead() -> void:
	SVC.visible = true
	player_dead = false

func _set_control(a: bool):
	in_control = a
