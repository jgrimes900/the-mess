@tool
## @entity PointClass
## @base Targetname, Origin, Angles
## @appearance iconsprite("mario64/goomball.vmt")
## Entity's description
class_name npc_goomba extends VMFEntityNode

## Use this method instead _ready
func _entity_ready() -> void:
	pass;

## This method is called during the import process
func _entity_setup(e: VMFEntity) -> void:
	pass;
