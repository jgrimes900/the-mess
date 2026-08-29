extends GPUParticles3D

@export var active: bool = false
@export var time: float = 1.0

func _spark() -> void:
	if active:
		do_spark()
		$"../Timer".wait_time = randf()*time
		$"../Timer".start()

func do_spark() -> void:
	emitting = true
