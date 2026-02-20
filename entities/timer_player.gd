extends Timer


# Called when the node enters the scene tree for the first time.
func start_player(_a, body, _c, _d) -> void:
	if body.name == "Player":
		start()
