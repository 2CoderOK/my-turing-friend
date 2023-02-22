class_name CanonGun
extends Position2D


const Ms = preload("res://src/Objects/Missile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire(dir):
	var missile = Ms.instance()
	missile.global_position = global_position
	if dir.x == -1:		
		missile.missile_dir = Missile.MissileDir.LEFT
	elif dir.x == 1:
		missile.missile_dir = Missile.MissileDir.RIGHT
	else:
		missile.missile_dir = Missile.MissileDir.CENTER

	missile.set_as_toplevel(true)
	add_child(missile)
