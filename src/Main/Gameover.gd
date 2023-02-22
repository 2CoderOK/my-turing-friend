extends Node2D


onready var timer = $Timer

var ok_next = false

func _ready():
	Data.reset()
	timer.start()

func _process(delta):
	pass

func _unhandled_input(event):
	if ok_next and event.is_pressed():
		$GameOverMusic.stop()
		get_tree().change_scene("res://src/Main/Menu.tscn")

func _on_Timer_timeout():
	ok_next = true
