extends RayCast3D

@export var distance: float = 25.0
@export var parent: CollisionObject3D
@export var damage: float = 1
@export var fire_delay: float = .5

var timer: float = fire_delay

func _ready() -> void:
	target_position = Vector3.DOWN * distance
	add_exception(parent)

func _fire() -> void:
	if timer >= fire_delay:
		timer = 0
		if is_colliding():
			if get_collider().get_node_or_null("Health"):
				get_collider().get_node("Health").damage(damage)

func _physics_process(delta: float) -> void:
	timer += delta
