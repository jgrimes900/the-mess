extends Area3D

class_name AreaWater3D

var player: Player
var speed_mod_id: int
var state: int
var shape: CollisionShape3D

const STATE_IDLE = 0
const STATE_RISING = 1
const STATE_DIVING = 2
const STATE_SWIMING = 3
const STATE_EXITING = 4

const RISE_SPEED = 2
const DIVE_SPEED = 1
const EXIT_SPEED = 5

var ply_last_y = Vector3.ZERO

func _ready() -> void:
	player = get_node("/root/Player") as Player;
	body_shape_entered.connect(func(_a1, a2, _a3, _a4):
			swim(a2))
	body_shape_exited.connect(func(_a1, a2, _a3, _a4):
			exit(a2))
	state = STATE_IDLE
	shape = $shape

func _physics_process(delta: float) -> void:
	match state:
		STATE_RISING:
			var aabb = shape.shape.get_debug_mesh().get_aabb().size
			aabb *= global_basis.get_scale()
			if player.is_on_floor() and player.global_position.y >= (aabb.y/2) + global_position.y:
				player.should_do_gravity = true
				player.overide_y_vel = false
			else:
				player.should_do_gravity = false
				player.overide_y_vel = true
				if player.target_velocity.y < 0:
					player.target_velocity.y = lerpf(player.target_velocity.y, RISE_SPEED, (delta)*(1-player.target_velocity.y))
				else:
					player.target_velocity.y += RISE_SPEED*delta
				if player.global_position.y >= (aabb.y/2) + global_position.y and player.target_velocity.y >= 0:
					player.global_position.y = (aabb.y/2)+ global_position.y
					player.target_velocity.y = 0
					state = STATE_SWIMING
					player.dive_timer = 0
		STATE_SWIMING:
			if Input.is_action_just_pressed("crouch"):
				state = STATE_DIVING
				player.dive_timer = 0
			if Input.is_action_just_pressed("jump"):
				state = STATE_EXITING
				player.target_velocity.y += EXIT_SPEED
		STATE_DIVING:
			if Input.is_action_pressed("crouch") and (player.dive_timer <= player.max_dive_time) and not player.is_on_floor():
				player.dive_timer += delta
				player.target_velocity.y = -DIVE_SPEED
			else:
				state = STATE_RISING
				

func swim(body: Node3D):
	if(player == body):
		speed_mod_id = player._add_mod("speed_cap", "/", 2)
		player.update_current_speed_cap()
		player.should_do_gravity = false
		player.should_do_crouch = false
		player.overide_y_vel = true
		#player.in_control = false
		state = STATE_RISING
			
func exit(body: Node3D):
	if(player == body):
		player._sub_mod("speed_cap", speed_mod_id)
		player.update_current_speed_cap()
		player.should_do_gravity = true
		player.should_do_crouch = true
		player.overide_y_vel = false
		state = STATE_IDLE
