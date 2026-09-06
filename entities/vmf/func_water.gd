@tool
## @entity SolidClass
## @base Targetname, Origin
## Entity's description
class_name func_water extends VMFEntityNode

var dmg: int = 0:
	get: return entity.get("dmg", 0);

## This method is called during the import process
func _entity_setup(_e: VMFEntity) -> void:
	# Applying mesh and collision shape for this entity
	var mesh := MeshInstance3D.new();
	mesh.mesh = get_mesh();
	
	mesh.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC

	add_child(mesh);
	mesh.set_owner(owner);
	mesh.name = "mesh";
	
	var trigger_fog := FogArea3D.new()
	var texture = (mesh.get_active_material(0) as BaseMaterial3D).albedo_texture.get_image()
	texture.decompress()
	texture.resize(1,1)
	trigger_fog.fog_color = texture.get_pixel(0,0)
	var fog_shape := CollisionShape3D.new();
	fog_shape.shape = get_entity_shape();
	trigger_fog.worldenv = $"../../../../WorldEnvironment"
	
	trigger_fog.add_child(fog_shape)
	add_child(trigger_fog)
	trigger_fog.set_owner(owner)
	fog_shape.set_owner(owner)
	trigger_fog.name = "fogarea"
	fog_shape.name = "shape"
	
	var water := AreaWater3D.new()
	var water_shape := CollisionShape3D.new();
	water_shape.shape = get_entity_shape();
	
	water.add_child(water_shape)
	add_child(water)
	water.set_owner(owner)
	water_shape.set_owner(owner)
	water.name = "waterarea"
	water_shape.name = "shape"

	if dmg != 0:
		var trigger_hurt := AreaHurt3D.new();
		trigger_hurt.damage = dmg
		trigger_hurt.is_per_second = true
		var collision_shape := CollisionShape3D.new();
		collision_shape.shape = get_entity_shape();
		
		add_child(trigger_hurt)
		trigger_hurt.add_child(collision_shape)
		trigger_hurt.set_owner(owner)
		collision_shape.set_owner(owner)
		trigger_hurt.name = "hurtarea"
		collision_shape.name = "shape"
