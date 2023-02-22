class_name Bomb
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	print("player detected")
	$AnimatedSprite.play("run")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "run":
		queue_free()
