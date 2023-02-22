class_name CanonFire
extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func sound_on():
	if not $BeamSound.is_playing():
		$BeamSound.play()

func sound_off():
	$BeamSound.stop()
	
func _on_Area2Center_body_entered(body):
	$AnimationPlayer.play("on_full")


func _on_Area2Center_body_exited(body):
	$AnimationPlayer.play("off")
