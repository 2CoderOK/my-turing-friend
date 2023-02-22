extends Node

onready var _pause_menu = $UI/IngameMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Area2D_area_entered(area):
	# remove missiles
	area.queue_free()


func _on_Area2D2_body_entered(body):
	$Level/Doors/DoorAnimationPlayer.play("break")

func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()

	elif event.is_action_pressed("toggle_pause"):
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			_pause_menu.open()
		else:
			_pause_menu.close()
		get_tree().set_input_as_handled()


func _on_Area2DVault_area_entered(area):
	$Level/AV.stop()
	$Level/AV/Camera2D.zoom = Vector2(0.7, 0.7)
	$Level/Doors/VaultAnimationPlayer.play("open")

func finish():
	get_tree().change_scene("res://src/Main/Ending.tscn")
