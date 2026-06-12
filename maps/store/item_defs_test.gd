extends Node

var Items: Array = [
	{
		"name": "Paper Box",
		"model": preload("res://assets/models/old_room_assets/storageBox_a001.mesh"),
		"size": Vector3(0.335, 0.274, 0.577),
		"scale": Vector3(1,1,1),
		"rotation": Vector3(0,90,0),
		"price": 9.99,
		"tags":["medium_size","stackable"]
	},
	{
		"name": "Stress Test",
		"model": preload("res://assets/models/old_room_assets/storageBox_a001.mesh"),
		"size": Vector3(0.00335, 0.00274, 0.00577),
		"scale": Vector3(0.01,0.01,0.01),
		"rotation": Vector3(0,90,0),
		"price": 0.01,
		"tags":["tiny_size","stackable"]
	}
]
