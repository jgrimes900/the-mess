extends GunBase

func select_setup():
	(get_node("AnimationPlayer") as AnimationPlayer).play("vm_arm_lib/fuckyou")

func _select(a:bool):
	super(a)
	visible = true
