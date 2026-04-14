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

var count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
