@tool
## @entity SolidClass
## @base Targetname, Origin
## Entity's description
class_name func_wall extends VMFEntityNode

## This method is called during the import process
func _entity_setup(_e: VMFEntity) -> void:
	# Applying mesh and collision shape for this entity
	var mesh := MeshInstance3D.new();
	mesh.mesh = get_mesh();
	
	mesh.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC

	var collision := StaticBody3D.new();

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
