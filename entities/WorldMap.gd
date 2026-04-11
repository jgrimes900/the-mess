extends CanvasLayer

@onready var tile_map: TileMap = $TileMap
@onready var name_label: Label = $NameLabel

# World map data
const MAP_POSITIONS = {
	"hl1_c1a0": Vector2i(3, 3),
	"gbj": Vector2i(1, 0),
	"GridMapTest": Vector2i(2, 6),
	"WinMap": Vector2i(7, 8),
	"StarkronDemo1": Vector2i(5, 4)
}

const MAP_NAMES = {
	"hl1_c1a0": "Half-Life Chapter 1",
	"gbj": "GBJ Level",
	"GridMapTest": "Grid Map Test",
	"WinMap": "Win Maze",
	"StarkronDemo1": "Starkron Demo"
}

const CONNECTIONS = {
	"hl1_c1a0": ["gbj"],
	"gbj": [],
	"GridMapTest": ["hl1_c1a0", "WinMap"],
	"WinMap": ["hl1_c1a0"],
	"StarkronDemo1": ["hl1_c1a0"]
}

# Tile IDs (assuming tileset has these)
const TILE_MAP = 0
const TILE_PATH = 2
const TILE_PLAYER = 1

var visible_2 = false

func _ready():
	hide()
	tile_map.add_layer(1)
	tile_map.set_layer_z_index(1, 1)
	setup_map()

func _input(event):
	if event.is_action_pressed("map"):
		toggle_map()

func toggle_map():
	if visible_2:
		hide()
	else:
		show()
		update_player_position()
	visible_2 = !visible_2

func setup_map():
	# Clear existing tiles
	tile_map.clear()
	
	# Place map tiles
	for map_key in MAP_POSITIONS:
		tile_map.set_cell(0, MAP_POSITIONS[map_key], 0, Vector2i(0, TILE_MAP))
	
	# Place path tiles between maps
	for from_map in CONNECTIONS:
		for to_map in CONNECTIONS[from_map]:
			if MAP_POSITIONS.has(to_map):
				draw_path(from_map, to_map)

func draw_path(from_map, to_map):
	var start = MAP_POSITIONS[from_map]
	var end = MAP_POSITIONS[to_map]
	var diff = end - start
	var steps = max(abs(diff.x), abs(diff.y))
	if steps == 0:
		return
	for i in range(1, steps):
		var t = float(i) / steps
		var pos = start + Vector2i((Vector2(diff) * t).round())
		tile_map.set_cell(0, pos, 0, Vector2i(0, TILE_PATH))

func update_player_position():
	# Remove old player tile
	for pos in tile_map.get_used_cells(1):
		tile_map.set_cell(1, pos, -1)  # Remove
	
	# Add new player tile
	var player_map = get_node("/root/Player").current_map
	if MAP_POSITIONS.has(player_map):
		var pos = MAP_POSITIONS[player_map]
		tile_map.set_cell(1, pos, 0, Vector2i(0, TILE_PLAYER))

func _process(_delta):
	if visible_2:
		var mouse_pos = get_viewport().get_mouse_position()
		var tile_pos = tile_map.local_to_map(tile_map.get_local_mouse_position())
		
		var map_key = null
		for key in MAP_POSITIONS:
			if MAP_POSITIONS[key] == tile_pos:
				map_key = key
				break
		
		if map_key:
			name_label.text = MAP_NAMES[map_key]
			name_label.position = mouse_pos + Vector2(10, 10)
			name_label.show()
		else:
			name_label.hide()
