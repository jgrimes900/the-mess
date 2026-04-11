extends Sprite3D

# Coin from The Simpsons: Hit and Run

@export var frames: int = 24
@export var frame_time: float = 0.01
@export var index: int = -1
@export var spawner: Node3D = null
@export var iframes: float = 0
@export var is_monster: bool = false
@export_category("Is Monster")
@export var life_time: float = 24
@export var gravity: float = 30.0

var velocity: Vector3
var timer = 0
@onready var player = get_node("/root/Player") as Player;

const COLLIDER_SIZE: Vector2 = Vector2(0.4,0.6)

signal collected(a: int)
signal spawner_notify(a: int, coin: Node3D)

func _ready() -> void:
	if is_monster:
		velocity = Vector3(randf_range(-2.5, 2.5), randf_range(0, 20), randf_range(-2.5, 2.5))
		iframes = 1
	var Hitbox = Area3D.new()
	var Collider = CollisionShape3D.new()
	var Shape = CylinderShape3D.new()
	Shape.height = COLLIDER_SIZE.y
	Shape.radius = COLLIDER_SIZE.x
	Hitbox.name = "Hitbox"
	add_child(Hitbox)
	Hitbox.add_child(Collider)
	Collider.shape = Shape
	Hitbox.connect("body_shape_entered", collect.unbind(2))
	connect("collected", player.recive_currency.bind("SHaR_Coin"))
	

func collect(_a, body):
	if body == player and iframes <= 0:
		collected.emit(index)
		spawner_notify.emit(index, self)
		queue_free()
	

func _process(delta: float) -> void:
	if timer >= frame_time:
		frame += 1
		if frame == frames:
			frame = 0
		timer = 0
	timer += delta
	if not is_monster:
		iframes -= delta
	if is_monster:
		var vec2 = Vector3(velocity.x, 0, velocity.z)
		var target = global_position + (velocity * delta)
		var query = PhysicsRayQueryParameters3D.create(global_position, target + (vec2.normalized() * COLLIDER_SIZE.x))
		query = get_world_3d().direct_space_state.intersect_ray(query)
		
		if query:
			# Check for literal corner case
			vec2 = vec2.slide(query.normal)
			target = global_position + (vec2 * delta)
			var query2 = PhysicsRayQueryParameters3D.create(global_position, target + (vec2.normalized() * COLLIDER_SIZE.x))
			query2 = get_world_3d().direct_space_state.intersect_ray(query2)
			if not query2:
				global_position = query.position - (-query.normal) * COLLIDER_SIZE.x + (velocity.slide(query.normal) * delta)
		else:
			global_position = target
			

func _physics_process(delta: float) -> void:
	if is_monster:
		var query = PhysicsRayQueryParameters3D.create(global_position, Vector3(global_position.x, global_position.y - COLLIDER_SIZE.y/2, global_position.z))
		query = get_world_3d().direct_space_state.intersect_ray(query)
		if !query:
			velocity.y -= gravity * delta
		else:
			velocity.y = 0.0
			global_position.y = query.position.y + COLLIDER_SIZE.y/2
			iframes = 0
