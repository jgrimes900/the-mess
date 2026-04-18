extends Control


@onready var num_posy = $a/b/Label.position.y

var move = -1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move > -1 and move < 64+27:
		move+=0.25
		$a/b/Label.position.y = num_posy-move

func _start():
	$a.visible = true
	$b.visible = false
	$a/b/Label.position.y = num_posy
	$chimes.play()
	mouse_filter = Control.MOUSE_FILTER_STOP
	$Timer.start()
	$"../Control/ambiance_1".stop()
	$"../Control/ambiance_2".stop()
	$"../Controler"._restet_a()
	get_node("/root/Player/Inv/TabContainer/Beads/FNaF Like")._unlock($"../Controler".night - 1)

func _on_timer_timeout() -> void:
	move = 0


func _on_chimes_finished() -> void:
	$Timer2.start()


func _on_timer_2_timeout() -> void:
	$"../Controler".night += 1
	if $"../Controler".night > 7:
		$"../Controler"._reset()
	else:
		$a.visible = false
		$b.visible = true
		$b/Label.text = "Night "+str($"../Controler".night)
		$Timer3.start()
		$"../Control/cam_change_sound".play()

func _on_timer_3_timeout() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	$"../Control/cam_change_sound".play()
	$"../Controler"._reset()
