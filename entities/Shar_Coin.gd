extends Sprite3D

@export var frames: int = 24
@export var frame_time: float = 0.01

var timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer >= frame_time:
		frame += 1
		if frame == frames:
			frame = 0
		timer = 0
	timer += delta
