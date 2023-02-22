extends Node2D

onready var exit_timer = $LiftExit/ExitMessageTimer
onready var nuts_text = $UI/Nuts
var first_time = true
onready var _pause_menu = $UI/IngameMenu
onready var _dialog_nuts = Dialogic.start("collect_resources")

func _ready():
	pass # Replace with function body.


func _process(delta):
	nuts_text.text = str(Data.nuts)

func _unpause_player(param):
	$Player._is_paused = false

func _unhandled_input(event):
	if event.is_action_pressed("toggle_pause"):
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			_pause_menu.open()
		else:
			_pause_menu.close()
		get_tree().set_input_as_handled()

func _on_LiftExit_body_entered(body):
	if Data.nuts < 30:
		if exit_timer.is_stopped():
			exit_timer.start()
			if not first_time:
				_dialog_nuts = Dialogic.start("collect_resources")
			add_child(_dialog_nuts)
			_dialog_nuts.connect("dialogic_signal", self, '_unpause_player')
			if not first_time:
				$Player._is_paused = true
				$Player.force_idle()
			first_time = false
	else:
		$Platforms/EnterLift/AnimationPlayer.play("exit")


func _on_LevelExit_body_entered(body):
	get_tree().change_scene("res://src/Level/LevelHome.tscn")
