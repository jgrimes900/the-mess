@tool
## @entity PointClass
## @base Targetname, Origin, Angles
## @appearance iconsprite("editor/shar_coin.vmt")
## Entity's description
class_name EntSharCoin extends VMFEntityNode

## Use this method instead _ready
func _entity_ready() -> void:
	pass;

## This method is called during the import process
func _entity_setup(e: VMFEntity) -> void:
	## Do setup things here
	pass;
