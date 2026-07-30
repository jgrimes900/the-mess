@tool
## @entity SolidClass
## @base Targetname, Origin
## Entity's description
class_name func_illusionary extends VMFEntityNode

## This method is called during the import process
func _entity_setup(_e: VMFEntity) -> void:
	# Applying mesh and collision shape for this entity
	var mesh := MeshInstance3D.new();
	mesh.mesh = get_mesh();
	
	if !mesh.mesh or mesh.mesh.get_surface_count() == 0:
		queue_free();
		return;

	if config.import.generate_lightmap_uv2:
		var unwrap_err = mesh.mesh.lightmap_unwrap(global_transform, config.import.lightmap_texel_size);
		if unwrap_err != OK:
			VMFLogger.warn("func_detail %s: lightmap_unwrap failed (%d), skipping UV2" % [entity.id, unwrap_err]);

	mesh.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC

	add_child(mesh);
	mesh.set_owner(owner);

	mesh.name = "mesh";
