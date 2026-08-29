@tool
## @entity PointClass
## @base Targetname, Origin, Angles
## @appearance iconsprite("editor/obsolete.vmt")
## Entity's description
class_name prop_physics extends prop_studio

func _entity_ready() -> void:
	pass
	
func _entity_setup(e: VMFEntity):
	super(e);

	if not model_instance: return;
	
	var rbody = RigidBody3D.new()
	rbody.basis = model_instance.basis
	rbody.name = "rbody"
	add_child(rbody)
	rbody.set_owner(get_owner())
	for collider in model_instance.find_children("*", "CollisionShape3D"):
		var c = collider.duplicate()
		rbody.add_child(c)
		c.set_owner(get_owner())
		print("a")
	var m = MeshInstance3D.new()
	m.mesh = model_instance.mesh
	rbody.add_child(m)
	m.name = "model"
	m.set_owner(get_owner())
	model_instance.free()
	
