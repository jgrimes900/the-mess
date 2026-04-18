extends ScrollContainer


var unlocked = [
]

var names = {
	"-1" = "One of the castles secret stars!",
	"0" = "The one, the only",
	"3" = "The three"
}

var font = preload("res://assets/fonts/sm64_large_2x.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
		
func init():
	if len(unlocked) == 0:
		for i in range(120):
			unlocked.append(false)
	for i in range(len(unlocked)):
		var star: Label = Label.new()
		if unlocked[i]:
			star.text = "\u0114 "
		else:
			star.text = "\u0115 "
		if str(i) in names:
			star.text = star.text + names[str(i)]
		else:
			star.text = star.text + names["-1"]
		star.label_settings = font
		star.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		star.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		star.name = str(i)
		$VBoxContainer.add_child(star)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _unlock(id: int, value: bool = true):
	unlocked[id] = value
	var str = ""
	if value:
		str = "\u0114 "
	else:
		str = "\u0115 "
	var popup: Control = $"../../../../HUD".popup_asset.instantiate()
	if str(id) in names:
		$VBoxContainer.get_child(id).text = str + names[str(id)]
		popup.text = names[str(id)]
	else:
		$VBoxContainer.get_child(id).text = str + names["-1"]
		popup.text = names["-1"]
	#popup.sprite = popup_sprites[0]
	$"../../../..".add_child(popup)
