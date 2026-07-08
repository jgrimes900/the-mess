extends Area3D

@onready var collider: CollisionShape3D = $Collision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "on_body_entered"))

func on_body_entered(body: Node3D):
	body.global_position
