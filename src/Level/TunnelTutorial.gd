extends Node


onready var _pause_menu = $UI/IngameMenu
var tutorial_finished = false

var ammo_bk = Data.shield_ammo
var fire_bk = Data.shield_fire
var cold_bk = Data.shield_cold
onready var player = $Level/AV

func _ready():
	player.is_tutorial = true

func _process(delta):
	pass

func _on_Area2D_area_entered(area):
	# remove missiles
	area.queue_free()

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

func _on_Area2DStop_body_entered(body):
	tutorial_finished = true
	$AnimationPlayer.play("fadeout")

func finish():
	Data.shield_ammo = ammo_bk
	Data.shield_fire = fire_bk
	Data.shield_cold = cold_bk
	get_tree().change_scene("res://src/Level/Tunnel.tscn")
