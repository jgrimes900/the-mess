extends Control

var open = true
var mode_2d = false
signal control(a: bool)

@onready var player = get_node("/root/Player") as Player;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("pause") and !open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_node("/root/Player").mouse_captured = false
		visible = true
		open = true
		emit_signal("control", false)
	if Input.is_action_just_pressed("open_inv"):
		if get_node("/root/Player").inv.visible:
			get_node("/root/Player").inv.visible = false
			if !mode_2d:
				get_node("/root/Player").in_control = true
				emit_signal("control", true)
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_node("/root/Player").mouse_captured = true
		else:
			get_node("/root/Player").inv.visible = true
			get_node("/root/Player").in_control = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_node("/root/Player").mouse_captured = false
			emit_signal("control", false)

func _gui_input_respawn():
	if open:
		get_node("/root/Node3D/Spawn").Respawn()
		get_node("/root/Player/Health").reset_health()
		get_node("/root/Player/Health").iframes = 5
		_gui_input_continue()
		
func _gui_input_continue():
	if open:
		if !mode_2d:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			emit_signal("control", true)
		get_node("/root/Player").mouse_captured = true
		visible = false
		open = false
		
func _2d_ify():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_node("/root/Player").mouse_captured = false
	mode_2d = true

func _un_2d():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_node("/root/Player").mouse_captured = true
	mode_2d = false
