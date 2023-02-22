extends Node2D


enum CanonDirs {
	LEFT,
	BOTTOM,
	RIGHT
}
var cur_dir = CanonDirs.BOTTOM
onready var canon_gun = get_node(@"CanonGun")

func _ready():
	pass



func move_canon(dir):
	if dir != cur_dir:
		if dir == CanonDirs.LEFT:
			$AnimationPlayer.play("bottom-left")
		elif dir == CanonDirs.RIGHT:
			$AnimationPlayer.play("bottom-right")
		else:
			if cur_dir == CanonDirs.LEFT:
				$AnimationPlayer.play("left-bottom")
			else:
				$AnimationPlayer.play("left-bottom")
		cur_dir = dir
			

func _on_Area2Left_body_entered(body):
	move_canon(CanonDirs.LEFT)
	$MissileTimer.start()


func _on_Area2Center_body_entered(body):
	move_canon(CanonDirs.BOTTOM)


func _on_Area2Right_body_entered(body):
	move_canon(CanonDirs.RIGHT)


func _on_Area2Right_body_exited(body):
	$MissileTimer.stop()


func _on_MissileTimer_timeout():
	if not $AnimationPlayer.is_playing():
		var dir = Vector2(0,1)
		if cur_dir == CanonDirs.LEFT:
			dir = Vector2(-1,1)
		elif cur_dir == CanonDirs.RIGHT:
			dir = Vector2(1,1)
		canon_gun.fire(dir)		
