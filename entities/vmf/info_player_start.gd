@tool
## @entity PointClass
## @base Targetname, Origin, Angles
## @appearance iconsprite("editor/obsolete.vmt")
## Entity's description
class_name info_player_start extends VMFEntityNode

const FLAG_IS_OFFSET = 1
const FLAG_IS_MAIN = 2

## @exposed
## @type vector
var offset: Vector3 = Vector3.ZERO

## This method is called during the import process
func _entity_setup(e: VMFEntity) -> void:
	$Spawn.is_offset = has_flag(FLAG_IS_OFFSET)
	$Spawn.main = has_flag(FLAG_IS_MAIN)
	$Spawn.offset = offset
