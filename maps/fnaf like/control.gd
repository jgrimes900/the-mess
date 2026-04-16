extends Control

@onready var office = $SubViewportContainer
@onready var CamCam = $CamCam

var move = 0
var speed_mod = 500

var def_x = 1152
var def_y = 648
@onready var ld_pos = Vector2($"SubViewportContainer/Left Door".position.x/def_x, $"SubViewportContainer/Left Door".position.y/def_y)
@onready var ll_pos = Vector2($"SubViewportContainer/Left Light".position.x/def_x, $"SubViewportContainer/Left Light".position.y/def_y)
@onready var rd_pos = Vector2($"SubViewportContainer/Right Door".position.x/def_x, $"SubViewportContainer/Right Door".position.y/def_y)
@onready var rl_pos = Vector2($"SubViewportContainer/Right Light".position.x/def_x, $"SubViewportContainer/Right Light".position.y/def_y)

var cam_def = Vector2(0.6, 0.6)
var cam_static_def = Vector2(0.9, 0.9)
var camcam_dir = 1
var camcam_state = 0

@onready var dl_size = Vector2(133.0/def_x, 107.0/def_y)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Control/TurnLeft1.connect("mouse_entered", _left_enter)
	$Control/TurnLeft2.connect("mouse_entered", _left_enter)
	$Control/TurnLeft3.connect("mouse_entered", _left_enter)
	$Control/TurnLeft1.connect("mouse_exited", _left_exit)
	$Control/TurnLeft2.connect("mouse_exited", _left_exit)
	$Control/TurnLeft3.connect("mouse_exited", _left_exit)
	$Control2/TurnRight1.connect("mouse_entered", _right_enter)
	$Control2/TurnRight2.connect("mouse_entered", _right_enter)
	$Control2/TurnRight3.connect("mouse_entered", _right_enter)
	$Control2/TurnRight1.connect("mouse_exited", _right_exit)
	$Control2/TurnRight2.connect("mouse_exited", _right_exit)
	$Control2/TurnRight3.connect("mouse_exited", _right_exit)
	$CamStatic.play()
	$CamStatic/AnimatedSprite2D.play()
	$DeathStatic.play()
	get_window().size_changed.connect(_on_window_resized)
	precalc_a = -self.size.x/2
	precalc_b = self.size.x/speed_mod
	precalc_c = self.size.x/speed_mod/2

var precalc_a
var precalc_b
var precalc_c

func _on_window_resized():
	$Control/TurnLeft1/CollisionShape2D.shape.size.y = self.size.y
	$Control/TurnLeft2/CollisionShape2D.shape.size.y = self.size.y
	$Control/TurnLeft3/CollisionShape2D.shape.size.y = self.size.y
	$Control2/TurnRight1/CollisionShape2D.shape.size.y = self.size.y
	$Control2/TurnRight2/CollisionShape2D.shape.size.y = self.size.y
	$Control2/TurnRight3/CollisionShape2D.shape.size.y = self.size.y
	
	$"SubViewportContainer/Left Door".position = self.size*ld_pos
	$"SubViewportContainer/Left Light".position = self.size*ll_pos
	$"SubViewportContainer/Right Door".position = self.size*rd_pos
	$"SubViewportContainer/Right Light".position = self.size*rl_pos
	
	$"SubViewportContainer/Left Door/CollisionShape2D".shape.size = self.size*dl_size
	$"SubViewportContainer/Left Light/CollisionShape2D".shape.size = self.size*dl_size
	$"SubViewportContainer/Right Door/CollisionShape2D".shape.size = self.size*dl_size
	$"SubViewportContainer/Right Light/CollisionShape2D".shape.size = self.size*dl_size
	
	$CamFlip.scale = cam_def*(self.size/Vector2(def_x, def_y))
	$CamStatic.scale = cam_static_def*(self.size/Vector2(def_x, def_y))
	$DeathStatic.scale = cam_static_def*(self.size/Vector2(def_x, def_y))
	precalc_a = -self.size.x/2
	precalc_b = self.size.x/speed_mod
	precalc_c = self.size.x/speed_mod/2
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	office.position.x += move*precalc_b
	if office.position.x > 0:
		office.position.x = 0
	if office.position.x < precalc_a:
		office.position.x = precalc_a
		
	CamCam.position.x += camcam_dir*precalc_c
	if CamCam.position.x > 0:
		CamCam.position.x = 0
		camcam_state = 1
		camcam_dir = 0
		$CamCam/Wait.start()
	if CamCam.position.x < precalc_a:
		CamCam.position.x = precalc_a
		camcam_state = 0
		camcam_dir = 0
		$CamCam/Wait.start()

func _left_enter():
	move += 1
	
func _left_exit():
	move -= 1
	
func _right_enter():
	move -= 1
	
func _right_exit():
	move += 1


func _on_wait_timeout() -> void:
	if camcam_state == 0:
		camcam_dir = 1
	else:
		camcam_dir = -1
		
