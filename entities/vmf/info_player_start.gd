@tool
## @entity PointClass
## @base Targetname, Origin, Angles
## @appearance iconsprite("editor/obsolete.vmt")
## Sets the player's spawn location.
class_name info_player_start extends VMFEntityNode

const FLAG_IS_OFFSET = 1
const FLAG_IS_NOT_MAIN = 2
const FLAG_IS_OFFSET_FROM_PREV_TELEPORT = 4

## @exposed
## @type vector
var offset: Vector3 = Vector3.ZERO

## @exposed
var rot_offset: float = 0.0

var from_maps = []

## This method is called during the import process
func _entity_setup(e: VMFEntity) -> void:
	$Spawn.is_offset = has_flag(FLAG_IS_OFFSET)
	$Spawn.main = !has_flag(FLAG_IS_NOT_MAIN)
	$Spawn.offset = offset
	$Spawn.is_offset_from_prev_teleport = has_flag(FLAG_IS_OFFSET_FROM_PREV_TELEPORT)
	$Spawn.rot_offset = e.data.rot_offset
	
	for key: String in e.data:
		if key.begins_with("from_map"):
			from_maps.append(e.data[key])
	$Spawn.from_maps = from_maps
