extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var wtext = text
	text = ""
	for char in wtext:
		print(char)
		text += char(ord(char)+0x100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
