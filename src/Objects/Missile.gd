class_name Missile
extends KinematicBody2D


var _velocity = Vector2(0, 0)

enum MissileDir {
	LEFT,
	CENTER,
	RIGHT
}

export var missile_dir = MissileDir.CENTER

func _ready():
	if missile_dir == MissileDir.CENTER:
		_velocity.y = 500
		_velocity.x = 0
	elif missile_dir == MissileDir.LEFT:
		self.rotate(rad2deg(-45.0))
		_velocity.y = 500
		_velocity.x = -500
	elif missile_dir == MissileDir.RIGHT:
		self.rotate(rad2deg(45.0))
		_velocity.y = 500
		_velocity.x = 500

func _process(delta):	
	_velocity = move_and_slide(_velocity)

func _on_Area2D_area_entered(area):
	var player := area.get_parent() as Player
	if player:
		player.hit()
		Data.hit(50)
	else:
		print("hit floor")
	queue_free()
