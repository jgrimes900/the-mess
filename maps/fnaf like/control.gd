extends Control

@onready var office = $SubViewportContainer

var move = 0
var speed_mod = 500

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
