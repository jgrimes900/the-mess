extends Node

@export var health: float = 100.0
@export var max_health: float = 100.0
@export var iframes: int = 0
@onready var root: Node = $"../"

signal dead()
signal damaged(amount: float)
signal healed(amount: float)
signal triggered()
signal reset()

func damage(amount: float, body: Node3D = null) -> void:
	if (body == root or body == null) and iframes <= 0:
		health -= amount
		if amount > 0:
			emit_signal("damaged", 0-amount)
		else:
			emit_signal("healed", amount)
		if health <= 0.0:
			emit_signal("dead")
		elif health > max_health:
			health = max_health
		emit_signal("triggered")

func damage_percent(percent: float, body: Node3D = null) -> void:
	damage(max_health * (percent / 100.0), body)
	
func reset_health() -> void:
	health = max_health
	emit_signal("reset")
