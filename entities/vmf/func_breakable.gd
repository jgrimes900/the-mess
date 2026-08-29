@tool
## @entity SolidClass
## @base Targetname, Origin
## Entity's description
class_name func_breakable extends VMFEntityNode

# Use @exposed tag to make them appear in the FGD file

## @exposed
var health: float = 5.0:
	get: return entity.get("health", 5.0);

## @exposed
var material: int:
	get: return entity.get("material", 2);

## Use this method instead _ready
func _entity_ready() -> void:
	$collision/Health.connect("damaged", Callable($collision/sound, "play").unbind(1))
	$collision/Health.connect("dead", Callable($collision, "_remove"))


## This method is called during the import process
func _entity_setup(_e: VMFEntity) -> void:
	# Applying mesh and collision shape for this entity
	var mesh := MeshInstance3D.new();
	mesh.mesh = get_mesh();

	var collision := StaticBody3D.new();
	collision.set_script(Remover)

	var collision_shape := CollisionShape3D.new();
	collision_shape.shape = get_entity_shape();
	
	var sound := AudioStreamPlayer3D.new()
	match material:
		_:
			sound.stream = load("res://assets/sounds/hl1/buttons/button11.wav")
			
	var health_obj := Health.new()
	health_obj.health = health
	health_obj.max_health = health

	add_child(collision);
	collision.add_child(collision_shape);
	collision.add_child(mesh);
	collision.add_child(sound)
	collision.add_child(health_obj)

	collision.set_owner(owner);
	collision_shape.set_owner(owner);
	mesh.set_owner(owner);
	sound.set_owner(owner)
	health_obj.set_owner(owner)

	collision.name = "collision";
	collision_shape.name = "shape";
	mesh.name = "mesh";
	sound.name = "sound"
	health_obj.name = "Health"

	## Do additional setup things here

## Inputs
func DoSomething(_void = null): pass;
