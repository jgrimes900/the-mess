extends Control

@onready var coin_types = {
	SHaR_Coin = $TabContainer/Currency/SHaR_Coin,
	USD = $TabContainer/Currency/USD
}

var coin_counts = {
	"SHaR_Coin" = 0,
	"USD" = 0
}

var items = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TabContainer/Currency/SHaR_Coin/Panel/AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func recive_currency(_index, type: String, amount: int = 1):
	if coin_types[type]:
		coin_counts[type] += amount
		coin_types[type].get_node("Label2").text = str(coin_counts[type])

func _give_item(item: String, quantity: int = 1):
	if !items.has(item):
		items[item] = 0
	items[item] += quantity

func _take_item(item: String, quantity: int = 1) -> bool:
	if items[item] >= quantity:
		items[item] -= quantity
		return true
	else:
		return false

func _unlock_beads(tab: int, value: bool = false):
	$TabContainer/Beads.set_tab_hidden(tab, value)
