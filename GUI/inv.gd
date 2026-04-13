extends Control

@onready var coin_types = {
	SHaR_Coin = $TabContainer/VBoxContainer/HBoxContainer,
	USD = $TabContainer/VBoxContainer/HBoxContainer2
}

var coin_counts = {
	SHaR_Coin = 0,
	USD = 0
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TabContainer/VBoxContainer/HBoxContainer/Panel/AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func recive_currency(_index, type: String, amount: int = 1):
	if coin_types[type]:
		coin_counts[type] += amount
		coin_types[type].get_node("Label2").text = str(coin_counts[type])
