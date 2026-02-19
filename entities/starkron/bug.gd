extends CharacterBody3D

# The ground enemy from Drillgon's current school project, Starkron

# If I limit it to only being in GridMap based levels,
# I might be able to implement the original method of pathing.

@onready var aniplay: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area3D = $AttackArea
@onready var body: Area3D = $AttackArea

@export var attack_delay: float = 1
@export var gravity: float = 30
@export var fall_cap: float = 100

var attack_timer: float = 0.0
var target_velocity: Vector3 = Vector3.ZERO
var attack_trigger_frames: int = -1

signal attack()

func _ready() -> void:
	_on_animation_finished("")

func _process(delta: float) -> void:
	attack_timer += delta
	attack_trigger_frames -= 1
	if attack_area.has_target and attack_timer >= attack_delay:
		attack_trigger_frames = 40
		aniplay.play("anim_lib_bug/attack")
		attack_timer = 0.0
	if attack_trigger_frames == 0:
		emit_signal("attack")

func _on_animation_finished(anim_name: StringName) -> void:
	aniplay.play("anim_lib_bug/walking")

func do_gravity(delta: float, velocity_in: Vector3):
	velocity_in.y -= gravity * delta
	if velocity_in.y > fall_cap:
		velocity_in.y = fall_cap
	return velocity_in
	
func _kill():
	queue_free()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		target_velocity = do_gravity(delta, target_velocity)
	velocity = target_velocity
	move_and_slide()
	
