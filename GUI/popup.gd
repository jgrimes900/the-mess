extends Control

@export var sprite: SpriteFrames
@export var text: String
@export var open_time: float = 4.0

enum STATE {OPENING, OPEN, CLOSING}

var state = STATE.OPENING

var moved = 0

var speed = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../HUD".popups_open += 1
	$Text/Label.text = text
	$Icon/AnimatedSprite2D.sprite_frames = sprite
	$Icon/AnimatedSprite2D.play()
	$Timer.wait_time = open_time
	position.x = get_window().size.x
	position.y = ($"../HUD".popups_open-1) * size.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		STATE.OPENING:
			print(position.x)
			position.x -= speed
			moved += speed
			if moved >= size.x:
				position.x += moved - size.x
				moved += moved - size.x
				state = STATE.OPEN
				$Timer.start()
		STATE.CLOSING:
			position.x += speed
			moved -= speed
			if moved <= 0:
				$"../HUD".popups_open -= 1
				queue_free()


func _on_timer_timeout() -> void:
	state = STATE.CLOSING
