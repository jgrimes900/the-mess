@tool
## @entity SolidClass
## @base Targetname, Origin
## Entity's description
class_name func_door_rotating extends VMFEntityNode

const FLAG_START_OPEN = 1
const FLAG_REVERSE_DIRECTION = 2
const FLAG_ONE_WAY = 16
const FLAG_TOGGLE = 32
const FLAG_X_AXIS = 64
const FLAG_Y_AXIS = 128
const FLAG_TOUCH_OPENS = 1024
const FLAG_GODOT_LIP = 8192

## @exposed
var speed: int = 100:
	get: return entity.get("speed", 100);
	
## @exposed
var distance: int = 0:
	get: return entity.get("distance", 0);
	
## @exposed
var wait: float = 4.0:
	get: return entity.get("wait", 4.0)

## This will be identified as Output
signal OnFullyOpen();
signal OnFullyClose();
signal OnOpen();
signal OnClose();

## Use this method instead _ready
func _entity_ready() -> void:
	if has_flag(FLAG_TOUCH_OPENS):
		$collision/trigger.connect("body_shape_entered", Callable($collision, "_on_touch"))
	$collision/Health.connect("triggered", Callable($collision, "_open"))
	
	$collision.connect("opened", func(): trigger_output(OnFullyOpen))
	$collision.connect("closed", func(): trigger_output(OnFullyClose))
	$collision.connect("start_open", func(): trigger_output(OnOpen))
	$collision.connect("start_close", func(): trigger_output(OnClose))


## This method is called during the import process
func _entity_setup(_e: VMFEntity) -> void:
	# Applying mesh and collision shape for this entity
	var mesh := MeshInstance3D.new();
	mesh.mesh = get_mesh();
	
	mesh.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC

	var collision := DoorRotating.new()

	var collision_shape := CollisionShape3D.new();
	collision_shape.shape = get_entity_shape();
	
	var health := Health.new()

	add_child(collision);
	collision.add_child(collision_shape);
	collision.add_child(mesh);
	collision.add_child(health)
	
	var trigger := Area3D.new()
	
	var trigger_shape := CollisionShape3D.new();
	trigger_shape.shape = get_entity_shape();
	
	trigger.scale = Vector3(1.05,1.05,1.05)
	collision.add_child(trigger)
	trigger.add_child(trigger_shape)
	
	
	collision.set_owner(owner);
	collision_shape.set_owner(owner);
	mesh.set_owner(owner);
	trigger.set_owner(owner)
	trigger_shape.set_owner(owner)
	health.set_owner(owner)

	collision.name = "collision";
	collision_shape.name = "shape";
	mesh.name = "mesh";
	health.name = "Health"
	trigger.name = "trigger"
	
	collision.close_time = -1 if has_flag(FLAG_TOGGLE) else wait
	if has_flag(FLAG_X_AXIS):
		collision.move_direction = Vector3.RIGHT
	elif has_flag(FLAG_Y_AXIS):
		collision.move_direction = Vector3.FORWARD
	else:
		collision.move_direction = Vector3.UP
	collision.move_speed = deg_to_rad(speed)
	collision.lip = distance
	collision.reverse = has_flag(FLAG_REVERSE_DIRECTION)
	collision.stay = has_flag(FLAG_ONE_WAY)
	collision.start_open_flag = has_flag(FLAG_START_OPEN)
	if !has_flag(FLAG_TOUCH_OPENS):
		trigger.queue_free()

## Inputs
func Open(_void = null): $collision._force_open();
func Close(_void = null): $collision._force_close();
func Toggle(_void = null): 
	print("toggled")
	$collision._open()
#func Lock(_void = null): $collision.can_use = false;
#func Unock(_void = null): $collision.can_use = true;
