extends Sprite3D

# Coin from The Simpsons: Hit and Run

@export var frames: int = 24
@export var frame_time: float = 0.01
@export var index: int = -1
@export var spawner: Node3D = null


var timer = 0
@onready var player = get_node("/root/Player") as Player;

signal collected(a: int)

func _ready() -> void:
	var Hitbox = Area3D.new()
	var Collider = CollisionShape3D.new()
	var Shape = CylinderShape3D.new()
	Shape.height = 0.6
	Shape.radius = 0.4
	Hitbox.name = "Hitbox"
	add_child(Hitbox)
	Hitbox.add_child(Collider)
	Collider.shape = Shape
	Hitbox.connect("body_shape_entered", collect.unbind(2))
	connect("collected", player.recive_currency.bind("SHaR_Coin"))
	

func collect(_a, body):
	if body == player:
		collected.emit(index)
		queue_free()

func _process(delta: float) -> void:
	if timer >= frame_time:
		frame += 1
		if frame == frames:
			frame = 0
		timer = 0
	timer += delta
