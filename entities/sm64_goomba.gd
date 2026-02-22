extends CharacterBody3D

# The ground enemy from Drillgon's current school project, Starkron

# If I limit it to only being in GridMap based levels,
# I might be able to implement the original method of pathing.

@onready var aniplay: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area3D = $HurtArea3D
@onready var notice_area: Area3D = $Notice_Area
@onready var stomp_area: Area3D = $StompArea
@onready var Body: Node3D = $Body_Root
@onready var player = get_node("/root/Player")

@export var attack_delay: float = 1
@export var gravity: float = 30
@export var fall_cap: float = 100
@export var home_radius: float = 10.00
@export var speed: float = 1.25
@export var run_speed_mult: float = 3
@export var coin_asset: Resource = preload("res://prefabs/shar_coin.tscn")

var attack_timer: float = 0.0
var target_velocity: Vector3 = Vector3.ZERO
var bounces: int = 3
var stomped: bool = false
var stomped_height = 0.1
var stomped_timer = 45
var home_area: Area3D 
var notice_state:bool = false
var home_exists:bool = false
var target_rot: float = 0
var choice_time: float = 0

signal attack()

func _ready() -> void:
	_on_animation_finished("")
	_setup_home.call_deferred()
	
func _setup_home():
	home_area = Area3D.new()
	var home_area_collider = CollisionShape3D.new()
	var shape = SphereShape3D.new()
	shape.radius = home_radius
	home_area_collider.shape = shape
	home_area.add_child(home_area_collider)
	get_node("../").add_child(home_area)
	home_area.global_position = global_position
	home_exists = true

func _process(delta: float) -> void:
	attack_timer += delta
	if attack_area.has_target and attack_timer >= attack_delay:
		attack_timer = 0.0
		emit_signal("attack")
		_jump()
		print("attack")

func _on_animation_finished(anim_name: StringName) -> void:
	aniplay.play("Walk")

func do_gravity(delta: float, velocity_in: Vector3):
	velocity_in.y -= gravity * delta
	if velocity_in.y > fall_cap:
		velocity_in.y = fall_cap
	return velocity_in
	
func _kill():
	var coin = coin_asset.instantiate()
	get_node("/root/Node3D").add_child(coin)
	_spawn_coin.call_deferred(global_position, coin)
	home_area.queue_free()
	queue_free()

func _spawn_coin(pos, coin):
	coin.global_position = pos
	coin.global_position.y += 0.5
	coin.iframes = 1
	

func _stomp(_a = null, body = player):
	if body == player and body.velocity.y <= 0:
		stomped = true

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
	if stomped:
		if Body.scale.y > stomped_height:
			Body.scale.y -= delta*6
		if Body.scale.y < stomped_height:
			Body.scale.y = stomped_height
		if abs(Body.scale.y-stomped_height) <= 0.01:
			stomped_timer -= 1
		if stomped_timer <= 0:
			_kill()
		target_velocity.x = 0
	else:
		if notice_area.overlaps_body(player) and home_area.overlaps_body(player) and home_area.overlaps_body(self):
			if notice_state == false:
				_jump()
				notice_state = true
			target_rot = deg_to_rad(atan2(player.position.x-position.x, player.position.z-position.z)*PI*18-90)
			target_velocity.x += delta
		else:
			notice_state = false
			target_velocity.x -= delta
			choice_time -= delta
		
		if home_exists and not home_area.overlaps_body(self):
			target_rot = deg_to_rad(atan2(home_area.position.x-position.x, home_area.position.z-position.z)*PI*18-90)
			
		rotation.y = rotate_toward(rotation.y, target_rot, delta*2.5)
		
		if target_velocity.x < speed:
			target_velocity.x = speed
		elif target_velocity.x > speed*run_speed_mult:
			target_velocity.x = speed*run_speed_mult
	velocity = target_velocity.rotated(Vector3.UP, rotation.y)
	move_and_slide()
	if choice_time <= 0 and is_on_floor():
		_make_move_choice()

func _jump():
	target_velocity.y = 6
	
func _make_move_choice():
	var choice = randi_range(1,8)
	if choice <= 6:
		if choice <= 3:
			target_rot += deg_to_rad(45)
		else:
			target_rot -= deg_to_rad(45)
		choice_time = randf_range(3,7)
	else:
		if choice == 8:
			target_rot += deg_to_rad(90+45)
		else:
			target_rot -= deg_to_rad(90+45)
		_jump()
