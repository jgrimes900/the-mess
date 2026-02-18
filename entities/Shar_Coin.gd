extends Sprite3D

@export var frames: int = 24
@export var frame_time: float = 0.01

var timer = 0

# TODO: Make it into a functional collectable, and not just a sprite
func _process(delta: float) -> void:
	if timer >= frame_time:
		frame += 1
		if frame == frames:
			frame = 0
		timer = 0
	timer += delta
