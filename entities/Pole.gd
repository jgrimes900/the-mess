@tool
extends Area3D

# An invisible, climbable pole.

# Suppost to work like the ones in Super Mario 64,
# but has a long way to go if I want it to be exactly the same.

@export var height: float = 2.0
@export var climb_speed: float = 2.0
@export var jump_speed: float = 16.0
@export var latch_time: float = 0.5

var state = 0
var player
var target_velocity = Vector3(0,0,0)
var speed_mod_id: int
var latch_time_timer: float = 0

func _ready() -> void:
	var Collider = CollisionShape3D.new();
	var Shape = CylinderShape3D.new();
	Shape.radius = 0.1;
	Shape.height = height;
	Collider.shape = Shape;
	add_child(Collider);
	Collider.position.y += height/2;
	
	player = get_node("/root/Player") as Player;
	body_shape_entered.connect(func(_a1, a2, _a3, _a4):
			_climb(a2))

func _physics_process(delta: float) -> void:
	if state == 1:
		latch_time_timer += delta
		if(player.is_on_floor()):
			_deactivate()
			return
		if Input.is_action_pressed("jump") and latch_time_timer >= latch_time:
			player.target_velocity = (Vector3.LEFT * jump_speed).rotated(Vector3.UP, player.get_node("Pivot").rotation.y)
			player.target_velocity.y = player.jump_vel
			player.in_control = true
			state = 2
			return
		elif Input.is_action_pressed("move_forward"):
			target_velocity.y = climb_speed
		elif Input.is_action_pressed("move_back"):
			target_velocity.y = -climb_speed
		else:
			target_velocity.y = 0
		player.velocity = target_velocity
		player.move_and_slide()
		if player.global_position.y > (global_position.y + height):
			_deactivate()
			return
	elif state == 2:
		if player.is_on_floor():
			_deactivate()
			target_velocity = Vector3.ZERO
			return
#		target_velocity = player.do_gravity(delta, target_velocity)
#		player.velocity = target_velocity
#		player.move_and_slide()
	
func _deactivate():
	player.in_control = true
	player._sub_mod("speed_cap", speed_mod_id)
	player.update_current_speed_cap()
	latch_time_timer = 0
	state = 0
	
func _climb(body):
	if(player == body):
		speed_mod_id = player._add_mod("speed_cap", "=", jump_speed)
		player.update_current_speed_cap()
		player.global_position.x = global_position.x
		player.global_position.z = global_position.z
		player.in_control = false
		if player.is_on_floor():
			target_velocity.y = climb_speed
			player.velocity = target_velocity
			player.move_and_slide()
		state = 1
