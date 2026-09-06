extends Node3D

@export var disabled = false
@onready var player = get_node("/root/Player")
@onready var area = $Area3D

const ITEM_NAME = "gravity_flipper"

func _ready() -> void:
	_set_disable(disabled)

func _move(pos: Vector3):
	position = pos
	$ButtonSliding.position = Vector3.ZERO

func _disable():
	if !disabled:
		visible = false
		disabled = !disabled
		area.collision_mask = 2
		player.get_node("Inv")._give_item(ITEM_NAME)
	elif player.get_node("Inv").items.has(ITEM_NAME):
		if player.get_node("Inv").items[ITEM_NAME] > 0:
			visible = true
			disabled = !disabled
			area.collision_mask = 1
			player.get_node("Inv")._take_item(ITEM_NAME)

func _set_disable(to_set: bool):
	visible = !to_set
	disabled = to_set
	area.collision_mask = int(to_set)+1
