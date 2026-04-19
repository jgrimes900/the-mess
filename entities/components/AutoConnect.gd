extends Node

@export var path: String
@export var signal_name: String
@export var function: String
@export var auto: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if auto:
		_connect.call_deferred()

func _connect() -> bool:
	var node = get_node(path)
	if node:
		var c = Callable.create(node, function)
		if c:
			$"..".connect(signal_name, c)
			return true
	printerr("_connect() failed for AutoConnect.gd:
	AC Path:"+path+"
	path:"+path+"
	signal_name:"+signal_name+"
	function:"+function)
	return false
