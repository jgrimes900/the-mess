extends AnimatedSprite2D

var a = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if a == 0:
		animation = "blackness"
	elif a == 4:
		get_node("/root/Player/Control").open = true
		get_node("/root/Player/Control")._gui_input_return()
	a += 1
