@tool
## @entity SolidClass
## @base Targetname, Origin
## Entity's description
class_name func_water extends VMFEntityNode

## This method is called during the import process
func _entity_setup(_e: VMFEntity) -> void:
	# Applying mesh and collision shape for this entity
	var mesh := MeshInstance3D.new();
	mesh.mesh = get_mesh();
	
	mesh.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC

	add_child(mesh);
	mesh.set_owner(owner);

	mesh.name = "mesh";
