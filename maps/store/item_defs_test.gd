extends Node

var Items: Array = [
	{
		"name": "Paper Box",
		"model": preload("res://models/irl/old_room_assets/storageBox_a001.mesh"),
		"size": Vector3(0.335, 0.274, 0.577),
		"scale": Vector3(1,1,1),
		"rotation": Vector3(0,90,0),
		"price": 9.99,
		"tags":["medium_size","stackable"],
		"offset": Vector3(0,0,0)
	},
	{
		"name": "Stress Test",
		"model": preload("res://models/irl/old_room_assets/storageBox_a001.mesh"),
		"size": Vector3(0.00335, 0.00274, 0.00577),
		"scale": Vector3(0.01,0.01,0.01),
		"rotation": Vector3(0,90,0),
		"price": 0.01,
		"tags":["tiny_size","stackable"],
		"offset": Vector3(0,0,0)
	},
	{
		"name": "keyboard",
		"model": preload("res://models/irl/keyboard.res"),
		"size": Vector3(0.315*3, 0.024*3, 0.105*3),
		"scale": Vector3(0.3,0.3,0.3),
		"rotation": Vector3(0,0,0),
		"price": 9.99,
		"tags":["medium_size"],
		"offset": Vector3(0,0,0.105*1.5)
	}
]
