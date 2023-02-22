extends Node2D


onready var gear := $Gear
onready var button1 := $Buttons/Button1
onready var button2 := $Buttons/Button2
onready var button3 := $Buttons/Button3
onready var timer1 := $Buttons/Button1Timer
onready var timer2 := $Buttons/Button1Timer2
onready var timer3 := $Buttons/Button1Timer3

var ammo_backup = Data.shield_ammo
var cold_backup = Data.shield_cold
var fire_backup = Data.shield_fire
var completed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if not completed:
		if timer1.is_stopped() and button1.is_down():
			timer1.start()
		elif timer2.is_stopped() and button2.is_down():
			timer2.start()
		elif timer3.is_stopped() and button3.is_down():
			timer3.start()
		
		if Data.shield_ammo >= 7 and Data.shield_cold >= 7 and Data.shield_fire >= 7:
			$UI/AnimationPlayer.play("fadeout")
			completed = true
		

func finish() -> void:
	Data.forge_gear = true
	Data.shield_ammo = ammo_backup
	Data.shield_cold = cold_backup
	Data.shield_fire = fire_backup
	get_tree().change_scene("res://src/Level/LevelHome.tscn")

func _on_Area2D_body_entered(body):
	gear.position = Vector2(-570, 420)
	gear.speed = Vector2(80, 100)
	gear._velocity = Vector2(80, 80)


func _on_Button1Timer_timeout():
	button1.randomize_buttons_and_arm(true)


func _on_Button1Timer2_timeout():
	button2.randomize_buttons_and_arm(true)


func _on_Button1Timer3_timeout():
	button3.randomize_buttons_and_arm(true)
