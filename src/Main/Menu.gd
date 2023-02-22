extends Node

onready var player_camera = $Layer/Player/Camera


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	player_camera.zoom = Vector2(0.8,0.8)
	Data.shield_ammo = 0
	Data.shield_fire = 0
	Data.shield_cold = 0
	Data.health = Data.health_max


func _on_Area2DQuit_body_entered(body):
	get_tree().quit()


func _on_Area2DPlay_body_entered(body):
	$MenuMusic.stop()
	if Data.intro_watched:
		get_tree().change_scene("res://src/Main/LevelHome.tscn")
	else:
		get_tree().change_scene("res://src/Main/Intro.tscn")
