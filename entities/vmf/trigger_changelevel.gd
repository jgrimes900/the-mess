@tool
## @entity SolidClass
## @base Targetname, Origin
## Changes the level to the one specified when the player touches it.
class_name trigger_changelevel extends VMFEntityNode

const FLAG_SILENT = 8
const FLAG_NO_SPRITE = 16

# Use @exposed tag to make them appear in the FGD file

## @exposed
var map: String = "":
	get: return entity.get("map", "");

## Use this method instead _ready
func _entity_ready() -> void:
	var trigger = $Area3d
	if !has_flag(FLAG_SILENT):
		trigger.connect("body_shape_entered", Callable.create(trigger, "MapChange").unbind(2))
	else:
		trigger.connect("body_shape_entered", Callable.create(trigger, "MapChange2").unbind(2))
	


## This method is called during the import process
func _entity_setup(_e: VMFEntity) -> void:

	var trigger = ent_LoadLevel.new()
	trigger.name = "Area3d"

	var collision_shape := CollisionShape3D.new();
	collision_shape.shape = get_entity_shape();
	
	add_child(trigger)
	trigger.add_child(collision_shape);

	trigger.set_owner(owner);
	collision_shape.set_owner(owner);

	collision_shape.name = "shape";
	
	trigger.LevelDef = map
	
		
	if !has_flag(FLAG_NO_SPRITE):
		var sprite = Sprite3D.new()
		sprite.texture = load("res://assets/sprites/dbg_portal.png")
		sprite.pixel_size = 0.02
		sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		trigger.add_child(sprite)
		sprite.set_owner(owner)
		sprite.name = "Sprite3d"

	## Do additional setup things here

## Inputs
func ChangeLevel(_void = null):
	if !has_flag(FLAG_SILENT):
		$Area3d.MapChange()
	else:
		$Area3d.MapChange2()
