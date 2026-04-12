extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("fade_in")


func _on_animation_finished(anim_name: StringName) -> void:
	$"../FadeIn".queue_free()
	queue_free()
