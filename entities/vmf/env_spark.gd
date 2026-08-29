@tool
## @entity PointClass
## @base Targetname, Origin, Angles
## @appearance iconsprite("editor/obsolete.vmt")
## Entity's description
class_name env_spark extends VMFEntityNode

const FLAG_START_ENABLED = 64

## @exposed
var MaxDelay: float = 1.0:
	get: return entity.get("MaxDelay", 1.0);

## Use this method instead _ready
func _entity_ready() -> void:
	$sparker._spark()

## This method is called during the import process
func _entity_setup(e: VMFEntity) -> void:
	$sparker.active = has_flag(FLAG_START_ENABLED)
	$sparker.time = MaxDelay

## Inputs
func StartSpark(_void = null): 
	$sparker.active = true
	$sparker._spark()
func StopSpark(_void = null): 
	$sparker.active = false
func ToggleSpark(_void = null): 
	if $sparker.active:
		StopSpark()
	else:
		StartSpark()
func SparkOnce(_void = null): 
	$sparker.do_spark()
	
