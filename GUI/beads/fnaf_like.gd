extends PanelContainer

@onready var beads = [
	$Control/night_1,
	$Control/night_2,
	$Control/night_3,
	$Control/night_4,
	$Control/night_5,
	$Control/night_6,
	$Control/night_7
]

var unlocked = [
	false,
	false,
	false,
	false,
	false,
	false,
	false
]

var popup_sprites = [
	preload("res://assets/sprites/beads/fnaf_like/popup/green_sf.tres"),
	preload("res://assets/sprites/beads/fnaf_like/popup/orange_sf.tres"),
	preload("res://assets/sprites/beads/fnaf_like/popup/red_sf.tres")
]

var count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"..".is_tab_hidden(0):
		$Control/Base.visible = false
		for bead: Sprite2D in beads:
			bead.visible = false
	else:
		$Control/Base.visible = true
		for bead: Sprite2D in beads:
			bead.visible = unlocked[count]
			count += 1
		count = 0
	
func _unlock(id: int, value: bool = true):
	unlocked[id] = value
	var popup: Control = $"../../../../HUD".popup_asset.instantiate()
	match id:
		5:
			popup.sprite = popup_sprites[1]
		6:
			popup.sprite = popup_sprites[2]
		_:
			popup.sprite = popup_sprites[0]
	popup.text = "Bead Obtained!"
	$"../../../..".add_child(popup)
