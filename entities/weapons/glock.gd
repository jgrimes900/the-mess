extends GunBase

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

func _ready() -> void:
	silencer.visible = has_silencer
	_idle_animation()

# TODO: Add sound, ammo, silencer, missing animations, and make the player have to pick it up first
func _process_next(delta: float) -> void:
	if Input.is_action_just_pressed("fire_left"):
		if gun._fire():
			Sounds.play()
			glock_anim.stop()
			arms_anim.stop()
			glock_anim.play("glock/shoot")
			arms_anim.play("vm_arm_lib/glock_shoot")

func _idle_animation():
	#aniplay.play("v_9mmhandgun_animation_lib/idle"+str(randi_range(1,3)))
	pass

func select_setup():
	glock_anim.play("glock/shoot") # replace with draw animation
	arms_anim.play("vm_arm_lib/glock_shoot")
