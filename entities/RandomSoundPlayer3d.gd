extends AudioStreamPlayer3D

class_name RandomSoundPlayer3D

@export var streams: Array[AudioStream]
@export var pitch_high: float = 1
@export var pitch_low: float = 1

func play_random(from_position: float = 0.0) -> void:
	if len(streams)>0:
		stream = streams[randi()%len(streams)]
		pitch_scale = randf_range(pitch_low,pitch_high)
		play()
	else:
		printerr(name,"(RandomSoundPlayer3d) tried to play sound, but has no streams assigned!")
