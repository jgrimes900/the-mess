extends RigidBody3D

var area: Area3D

func _ready() -> void:
	area = Area3D.new()
	var col = CollisionShape3D.new()
	col.shape = $CollisionShape3D.shape
	add_child(area)
	area.add_child(col)
	area.connect("body_entered", _wakeup)

func _wakeup(body):
	if body != self:
		freeze = false
		area.queue_free()
