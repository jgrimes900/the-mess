extends Control

var popups_open = 0

var popup_asset: Resource = preload("res://prefabs/UI/popup.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HealthBar.max_value = $"../Health".max_health
	$HealthBar.value = $"../Health".health
