extends CharacterBody3D


@export var speed: float = 8.0
@export var jump_vel: float = 9.0
@export var gravity: float = 30.0
@export var fall_cap: float = 100.0
@export var speed_cap: float = 8
@export var collision_size: Vector3 = Vector3(0.75, 1.8, 0.75)
@export var collision_mult_crouched: Vector3 = Vector3(1.0, 0.5, 1.0)
@export var in_control: bool = true
@export var look_sensitivity: float = 100
@export var rotation_mod: Vector3 = Vector3(0, 0, 0)
@export var friction_ground: float = 0.9999
@export var friction_air: float = 0.8

var dead = false
var view_pitch: float = 0.0
var view_pitch_set: int = 0
var last_y: float = 0.0
var target_velocity: Vector3 = Vector3.ZERO
@export var mouse_captured: bool = false
var crouched: bool = false
var death_rotation: Vector3 = Vector3(90, 0, 0)
var alive_rotation: Vector3 = Vector3(0, 0, 0)
var basis_temp: Basis
var rotation_mod_unit: Vector3
var rot_temp: Vector3
var local_pos: Vector3

@onready var pivot: Node3D = $Pivot
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var sound_player: AudioStreamPlayer3D = $AudioTele

const coin_sounds = {
	SHaR_Coin = 3,
	SHaR_Coin1 = preload("uid://do0hcpe20agk3"),
	SHaR_Coin2 = preload("uid://b3kofhrj1ec5k"),
	SHaR_Coin3 = preload("uid://dlnm6thk8215s")
}

func rotate_ply(rotation_a: Vector3):
	rotation_degrees = rotation_a + rotation_mod

func _kill():
	dead = true
	rotate_ply(death_rotation)
func _unkill():
	dead = false
	rotate_ply(alive_rotation)

func _physics_process(delta: float) -> void:
	get_node("Health").iframes -= 1
	if dead:
		rot_temp = rotation - Vector3(deg_to_rad(death_rotation.x),deg_to_rad(death_rotation.y),deg_to_rad(death_rotation.z))
	else:
		rot_temp = rotation
	local_pos = (Basis.from_euler(rot_temp) * position)
	if in_control:
		var direction := Vector3.ZERO
		
		if !dead:
			if Input.is_action_pressed("move_right"):
				direction.z -= 1.0
			if Input.is_action_pressed("move_left"):
				direction.z += 1.0
			if Input.is_action_pressed("move_back"):
				direction.x += 1.0
			if Input.is_action_pressed("move_forward"):
				direction.x -= 1.0
				
			# TODO: Check if the player can uncrouch with a shapecast
			if Input.is_action_pressed("crouch") and not crouched:
				var shape: BoxShape3D = collision_shape.shape
				shape.size = collision_size * collision_mult_crouched
				collision_shape.position.y += collision_size.y * collision_mult_crouched.y
				pivot.position.y += shape.size.y/2
				local_pos.y -= shape.size.y/2
				speed_cap = speed_cap/2
				crouched = true
			elif not Input.is_action_pressed("crouch") and crouched:
				var shape: BoxShape3D = collision_shape.shape
				shape.size = collision_size
				collision_shape.position.y -= collision_size.y * collision_mult_crouched.y
				position.y += collision_size.y * collision_mult_crouched.y
				pivot.position.y -= (collision_size.y * collision_mult_crouched.y)/2
				local_pos.y += (collision_size.y * collision_mult_crouched.y)/2
				speed_cap = speed_cap*2
				crouched = false

		if abs(local_pos.y - last_y) <= 0.001:
			target_velocity.y = 0
			
		if not is_on_floor():
			target_velocity = do_gravity(delta, target_velocity)
		elif !dead and Input.is_action_pressed("jump"):
			target_velocity.y += jump_vel
			
		if direction != Vector3.ZERO:
			direction = (direction.normalized() * speed).rotated(Vector3.UP, pivot.rotation.y)
		
		target_velocity.x += direction.x
		target_velocity.z += direction.z
		if (target_velocity*Vector3(1,0,1)).length() > speed_cap:
			target_velocity = ((target_velocity*Vector3(1,0,1)).normalized()*speed_cap)+(target_velocity*Vector3(0,1,0))
		var friction
		if is_on_floor():
			friction = friction_ground
		else:
			friction = friction_air
		target_velocity.x += (target_velocity.x) * exp(delta * log(1.0 - friction)) - (target_velocity.x) 
		target_velocity.z += (target_velocity.z) * exp(delta * log(1.0 - friction)) - (target_velocity.z) 
		
		last_y = local_pos.y
		
		up_direction = Basis.from_euler(rot_temp).y
		velocity = Basis.from_euler(rot_temp) * target_velocity
		
		move_and_slide()

func do_gravity(delta: float, velocity_in: Vector3):
	velocity_in.y -= gravity * delta
	if velocity_in.y > fall_cap:
		velocity_in.y = fall_cap
	return velocity_in

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if view_pitch_set == 1:
			view_pitch = 1.5
			view_pitch_set = 0
		elif view_pitch_set == -1:
			view_pitch = -1.5
			view_pitch_set = 0
			
		if mouse_captured:
			pivot.rotate_y(-event.relative.x / (100.0*(100/look_sensitivity)))
			
			var pitch_delta = event.relative.y / (150.0*(100/look_sensitivity))
			var new_pitch = view_pitch - pitch_delta
			
			if new_pitch <= 1.5 and new_pitch >= -1.5:
				pivot.rotate_object_local(Vector3.FORWARD, -pitch_delta)
				view_pitch = new_pitch
			elif new_pitch >= 1.5:
				pivot.rotation = Vector3(0, pivot.rotation.y, -1.5)
				view_pitch_set = 1
			elif new_pitch <= -1.5:
				pivot.rotation = Vector3(0, pivot.rotation.y, 1.5)
				view_pitch_set = -1
				
func recive_currency(_index, type: String):
	if coin_sounds[type]:
		sound_player.stream = coin_sounds[type + str(randi_range(1,coin_sounds[type]))]
		sound_player.play()
		
func set_look_sensitivity(value: float):
	look_sensitivity = value
