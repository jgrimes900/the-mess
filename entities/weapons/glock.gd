extends Node3D

@export var has_silencer: bool = false

@onready var aniplay: AnimationPlayer = $AnimationPlayer
@onready var gun: RayCast3D = $Gun
@onready var silencer: MeshInstance3D = $"SVC/SubViewport/v_9mmhandgun_qc_skeleton/Skeleton3D/glock_reference(silencer)"
@onready var SVC: SubViewportContainer = $SVC

var player_dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	silencer.visible = has_silencer
	_idle_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("fire_left") and !player_dead:
		gun._fire()
		aniplay.play("v_9mmhandgun_animation_lib/shoot")

func _idle_animation():
	aniplay.play("v_9mmhandgun_animation_lib/idle"+str(randi_range(1,3)))


func _player_dead() -> void:
	SVC.visible = false
	player_dead = true
