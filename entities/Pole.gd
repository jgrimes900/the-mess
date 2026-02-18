@tool
extends Area3D

@export var height: float = 2.0
@export var climb_speed: float = 2.0
@export var jump_speed: float = 16.0

var state = 0
var player
var target_velocity = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if state == 1:
		if(player.is_on_floor()):
			_deactivate()
			pass
		if Input.is_action_pressed("jump"):
			target_velocity = (Vector3.FORWARD * jump_speed).rotated(Vector3.UP, player.get_node("Pivot").rotation.y)
			target_velocity.y = player.jump_vel
			state = 2
			pass
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
	elif state == 2:
		if player.is_on_floor():
			_deactivate()
			target_velocity = Vector3.ZERO
			pass
		target_velocity = player.do_gravity(delta, target_velocity)
		player.velocity = target_velocity
		player.move_and_slide()
	
func _deactivate():
	player.in_control = true
	state = 0
	
func _climb(body):
	if(player == body):
		player.position.x = position.x
		player.position.z = position.z
		player.in_control = false
		if player.is_on_floor():
			target_velocity.y = climb_speed
			player.velocity = target_velocity
			player.move_and_slide()
		state = 1
