extends CharacterBody3D

# The ground enemy from Drillgon's current school project, Starkron

# If I limit it to only being in GridMap based levels,
# I might be able to implement the original method of pathing.

@onready var aniplay: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area3D = $HurtArea3D
@onready var notice_area: Area3D = $Notice_Area
@onready var player = get_node("/root/Player")

@export var attack_delay: float = 1
@export var gravity: float = 30
@export var fall_cap: float = 100

var attack_timer: float = 0.0
var target_velocity: Vector3 = Vector3.ZERO
var bounces: int = 3

signal attack()

func _ready() -> void:
	_on_animation_finished("")

func _process(delta: float) -> void:
	attack_timer += delta
	if attack_area.has_target and attack_timer >= attack_delay:
		attack_timer = 0.0
		emit_signal("attack")

func _on_animation_finished(anim_name: StringName) -> void:
	aniplay.play("Walk")

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
		if bounces == -1:
			bounces = 3
	if is_on_floor() and bounces > 1:
		target_velocity.y = 1 * bounces
		bounces -= 1
	if is_on_floor() and bounces <= 1 and bounces > -1:
		bounces -= 1
	velocity = target_velocity
	move_and_slide()
	if notice_area.overlaps_body(player):
		print("A:"+str(atan2(player.position.x-position.x, player.position.z-position.z)*PI*18-90))
		print("B:"+str(rotation_degrees.y))
		rotation.y = rotate_toward(rotation.y, deg_to_rad(atan2(player.position.x-position.x, player.position.z-position.z)*PI*18-90), delta*1.5)


func _on_notice_area_enter(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body == player:
		_jump()

func _jump():
	target_velocity.y = 6
