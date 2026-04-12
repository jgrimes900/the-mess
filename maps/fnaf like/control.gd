extends Control

@onready var office = $SubViewportContainer

var move = 0
var speed_mod = 500

var def_x = 1152
var def_y = 648
@onready var ld_pos = Vector2($"SubViewportContainer/Left Door".position.x/def_x, $"SubViewportContainer/Left Door".position.y/def_y)
@onready var ll_pos = Vector2($"SubViewportContainer/Left Light".position.x/def_x, $"SubViewportContainer/Left Light".position.y/def_y)
@onready var rd_pos = Vector2($"SubViewportContainer/Right Door".position.x/def_x, $"SubViewportContainer/Right Door".position.y/def_y)
@onready var rl_pos = Vector2($"SubViewportContainer/Right Light".position.x/def_x, $"SubViewportContainer/Right Light".position.y/def_y)

var cam_def = Vector2(0.6, 0.6)

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	
	office.position.x += move*(self.size.x/speed_mod)
	if office.position.x > 0:
		office.position.x = 0
	if office.position.x < -self.size.x/2:
		office.position.x = -self.size.x/2

func _left_enter():
	move += 1
	
func _left_exit():
	move -= 1
	
func _right_enter():
	move -= 1
	
func _right_exit():
	move += 1
