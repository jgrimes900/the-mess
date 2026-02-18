extends Area3D

@export var damage: float = 0.0
@export var is_percent: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_percent:
		body_shape_entered.connect(func(_a1, body, _a3, _a4):
			if body.get_node_or_null("Health"):
				body.get_node("Health").damage_percent(damage, body))
	else:
		body_shape_entered.connect(func(_a1, body, _a3, _a4):
			if body.get_node_or_null("Health"):
				body.get_node("Health").damage(damage, body))
