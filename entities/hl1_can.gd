class_name hl1_can extends AnimatableBody3D

@onready var mesh: MeshInstance3D = $mesh
@onready var pickup_area: Area3D = $pickup_area3d
@onready var ply: Player = $"/root/Player"
@onready var soundplayer: AudioStreamPlayer3D = $sound_player

@export var gravity: float = 0.5
var target_velocity: Vector3 = Vector3.ZERO
var col: KinematicCollision3D
var landed: bool = false

var textures = [
	preload("res://assets/materials/hl1/vending/can/1.tres"),
	preload("res://assets/materials/hl1/vending/can/2.tres"),
	preload("res://assets/materials/hl1/vending/can/3.tres"),
	preload("res://assets/materials/hl1/vending/can/4.tres"),
	preload("res://assets/materials/hl1/vending/can/5.tres"),
	preload("res://assets/materials/hl1/vending/can/6.tres")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh.mesh.surface_set_material(1, textures[randi_range(0,textures.size()-1)])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	target_velocity.y -= gravity * delta
	col = move_and_collide(target_velocity)
	if col:
		target_velocity.y = 0
		if !landed:
			soundplayer.play()
			landed = true
	else:
		landed = false
	


func _on_pickup_area_3d_body_entered(body: Node3D) -> void:
	if body == ply:
		ply.get_node("Health").damage(-1)
		queue_free()
