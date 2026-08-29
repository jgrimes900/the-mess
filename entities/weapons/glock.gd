extends Node3D

# The glock / 9mm Pistol from Half-Life 1

# Not accurate to the original thing.
# Honestly, this is here because I had the model on-hand
# Same thing with C1A0

@export var has_silencer: bool = false

@onready var arms_anim: AnimationPlayer = $"../vm_arm/AnimationPlayer"
@onready var glock_anim: AnimationPlayer = $"v_hl1_glock/AnimationPlayer"
@onready var gun: RayCast3D = $Gun
@onready var silencer: MeshInstance3D = $"v_hl1_glock/v_9mmhandgun_qc_skeleton_001/Skeleton3D/glock_reference(silencer)"
@onready var Sounds: AudioStreamPlayer3D = $GunSounds

var player_dead = false
var in_control: bool = true
var active: bool = false

func _ready() -> void:
	silencer.visible = has_silencer
	_idle_animation()

# TODO: Add sound, ammo, silencer, missing animations, and make the player have to pick it up first
func _process(delta: float) -> void:
	if active:
		if Input.is_action_just_pressed("fire_left") and !player_dead and in_control:
			if gun._fire():
				Sounds.play()
				glock_anim.stop()
				arms_anim.stop()
				glock_anim.play("glock/shoot")
				arms_anim.play("vm_arm_lib/glock_shoot")

func _idle_animation():
	#aniplay.play("v_9mmhandgun_animation_lib/idle"+str(randi_range(1,3)))
	pass

func _select(a:bool):
	if a:
		active = true
		$v_hl1_glock.visible = true
		glock_anim.play("glock/shoot") # replace with draw animation
		arms_anim.play("vm_arm_lib/glock_shoot")
	else:
		active = false
		$v_hl1_glock.visible = false
		

func _player_dead() -> void:
	$v_hl1_glock.visible = false
	player_dead = true
	
func _player_undead() -> void:
	$v_hl1_glock.visible = true
	player_dead = false

func _set_control(a: bool):
	in_control = a
