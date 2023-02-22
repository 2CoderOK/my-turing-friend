class_name Nut
extends Area2D

onready var animation_player = $AnimationPlayer
onready var sound = $PickupSound
var already_played = false

func _on_body_entered(_body):
	$CollisionShape2D.free()
	animation_player.play("picked")
	sound.play()
	Data.nuts += 1

func _ready():
	animation_player.seek(rand_range(0,3))
