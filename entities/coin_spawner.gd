extends Node3D

enum SPAWN_SHAPE {GROUND_LINE, GROUND_RING, AIR_LINE, AIR_RING}

@export var spawn_radius: float = 15.00
@export var coin_asset: Resource = preload("res://prefabs/shar_coin.tscn")
@export var spawn_shape: SPAWN_SHAPE

@onready var _player: CharacterBody3D = get_node("/root/Player")

var spawn_area: Area3D
var coins_spawned: bool = false
var coins_collected
var coins = []

const RAY_LENGTH = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_area = Area3D.new()
	var spawn_area_collider = CollisionShape3D.new()
	var shape = SphereShape3D.new()
	shape.radius = spawn_radius
	spawn_area_collider.shape = shape
	spawn_area.add_child(spawn_area_collider)
	add_child(spawn_area)
	if spawn_shape == SPAWN_SHAPE.GROUND_RING or spawn_shape == SPAWN_SHAPE.AIR_RING:
		coins_collected = [false,false,false,false,false,false,false,false]
	else:
		coins_collected = [false,false,false,false,false,false]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawn_area.overlaps_body(_player) and !coins_spawned:
		match spawn_shape:
			SPAWN_SHAPE.GROUND_LINE:
				var space_state = get_world_3d().direct_space_state
				var query
				var result
				var vec: Vector3
				for i in range(1,6):
					if !coins_collected[i]:
						var coin: Node3D = coin_asset.instantiate()
						coin.index = i
						vec = Vector3(i-3,0,0)
						print(vec)
						vec = vec.rotated(Vector3.UP, rotation.y)
						print(vec)
						vec += global_position
						query = PhysicsRayQueryParameters3D.create(vec, Vector3(vec.x, vec.y - RAY_LENGTH, vec.z))
						result = space_state.intersect_ray(query)
						if result:
							result = result.position
							result.y += 0.5
							_spawn_coin.call_deferred(result, coin)
							add_child(coin)
							coin.connect("spawner_notify", func(index, coin_to_erase):
								coins_collected[index] = true
								coins.erase(coin_to_erase))
							coins.append(coin)
						else:
							print("Coin failed to find ground at "+str(vec))
				coins_spawned = true
	elif !spawn_area.overlaps_body(_player) and coins_spawned:
		for coin in coins:
			coin.queue_free()
			coins_spawned = false
		coins = []
		
func _spawn_coin(position: Vector3, coin):
	coin.global_position = position
