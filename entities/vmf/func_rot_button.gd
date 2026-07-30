@tool
## @entity SolidClass
## @base Targetname, Origin
## Entity's description
class_name func_rot_button extends VMFEntityNode

#const FLAG_DONT_MOVE = 1
const FLAG_START_OPEN = 1
const FLAG_REVERSE_DIRECTION = 2
const FLAG_TOGGLE = 32
const FLAG_X_AXIS = 64
const FLAG_Y_AXIS = 128

## @exposed
var speed: int = 100:
	get: return entity.get("speed", 100);
	
## @exposed
var distance: int = 0:
	get: return entity.get("distance", 0);
	
## @exposed
var wait: float = 4.0:
	get: return entity.get("wait", 4.0)

## @exposed
## @type target_destination
var target_node: Node:
	get: return get_target(entity.get("target_node", ""));

## @exposed
## @type angles
var movedir: Vector3 = Vector3.ZERO:
	get: return Basis.from_euler(convert_direction(entity.get("angles_property", Vector3.ZERO))) * Vector3.FORWARD;

## This will be identified as Output
signal OnPressed();

## Use this method instead _ready
func _entity_ready() -> void:
	$collision.connect("opened", func(): trigger_output(OnPressed))


## This method is called during the import process
func _entity_setup(_e: VMFEntity) -> void:
	# Applying mesh and collision shape for this entity
	var mesh := MeshInstance3D.new();
	mesh.mesh = get_mesh();
	mesh.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC

	var collision := ButtonRotating.new()

	var collision_shape := CollisionShape3D.new();
	collision_shape.shape = get_entity_shape();

	add_child(collision);
	collision.add_child(collision_shape);
	collision.add_child(mesh);

	collision.set_owner(owner);
	collision_shape.set_owner(owner);
	mesh.set_owner(owner);

	collision.name = "collision";
	collision_shape.name = "shape";
	mesh.name = "mesh";
	
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
	
	## Do additional setup things here

## Inputs
func Use(_void = null): Press(_void);
func Press(_void = null): 
	if($collision._on_use()):
		trigger_output(OnPressed)
func Lock(_void = null): $collision.can_use = false;
func Unock(_void = null): $collision.can_use = true;
