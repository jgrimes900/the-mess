extends Node3D


var size: Vector3
@export var item_scale: Vector3 = Vector3(1,1,1)
@export var item_tags: Array[String]
@export var is_blacklist: bool = true

@onready var tag_node = $"Tag"
@onready var collider: Area3D = $"Collider"
@onready var itemDefs = $"../../ItemDefs"

var item = 0
var count = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = $"Collider/CollisionShape3D".shape.size
	var temp1: Vector3 = size / itemDefs.Items[item].size
	var temp2: Vector3i = temp1.floor()
	temp1 = temp1 - temp1.floor()
	var offset: Vector3 = size - itemDefs.Items[item].size
	offset = Vector3(-offset.x/2, itemDefs.Items[item].size.y/2, -offset.z/2)
	var count2 = 0
	
	for i in temp2.z:
		for j in temp2.x:
			count2 += 1
			if count2 < count:
				var model: MeshInstance3D = MeshInstance3D.new()
				model.mesh = itemDefs.Items[item].model
				model.position = Vector3(
					(j+((temp1.x/(temp2.x+1))*(j+1))) * itemDefs.Items[item].size.x,
					0,
					(i+((temp1.z/(temp2.z+1))*(i+1))) * itemDefs.Items[item].size.z
				)
				model.position += offset
				model.rotation_degrees = itemDefs.Items[item].rotation
				add_child(model)
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
