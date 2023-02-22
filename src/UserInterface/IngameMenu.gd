extends Control


onready var center_cont = $ColorRect/CenterContainer
onready var resume_button = center_cont.get_node(@"VBoxContainer/ResumeButton")

onready var root = get_tree().get_root()
onready var scene_root = root.get_child(root.get_child_count() - 1)


func _ready():
	hide()

func close():
	get_tree().paused = false
	modulate.a = 0.0
	hide()

func open():
	modulate.a = 1.0
	show()
	resume_button.grab_focus()


func _on_ResumeButton_pressed():
	close()


func _on_QuitButton_pressed():
	Data.reset()
	Data.forge_gear = false
	get_tree().paused = false
	get_tree().change_scene("res://src/Main/Menu.tscn")

