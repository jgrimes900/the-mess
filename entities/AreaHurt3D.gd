extends Area3D

@export var damage: float = 0.0
@export var is_percent: bool = false
@export var is_per_second = false

var bodys_inside = []
var damage_to_apply: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		body_shape_entered.connect(func(_a1, body, _a3, _a4):
			bodys_inside.append(body))
		body_shape_exited.connect(func(_a1, body, _a3, _a4):
			bodys_inside.erase(body))

func _physics_process(delta: float) -> void:
	_calc_damage(delta)
	for body in bodys_inside:
		_damage(body)

func _calc_damage(delta: float):
	damage_to_apply = damage
	if is_per_second:
		damage_to_apply *= delta

func _damage(body):
	if body.get_node_or_null("Health"):
		if is_percent:
			body.get_node("Health").damage_percent(damage_to_apply, body)
		else:
			body.get_node("Health").damage(damage_to_apply, body)
