extends Node2D

var cur_page = 1
onready var timer = $Timer
onready var page = $Text/Page1
var ok_next = false


func _ready():
	$Text/Page1.set_visible(true)
	timer.start()


func _process(delta):
	pass


func _unhandled_input(event):
	if ok_next and event.is_pressed():
		ok_next = false
		cur_page += 1
		if cur_page == 2:
			$Text/Page1.set_visible(false)
			$Text/Page2.set_visible(true)
		elif cur_page == 3:
			$Text/Page2.set_visible(false)
			$Text/Page3.set_visible(true)
		elif cur_page == 4:
			$Text/Page3.set_visible(false)
			$Text/Page4.set_visible(true)
		elif cur_page == 5:
			$Text/Page4.set_visible(false)
			$Text/Page5.set_visible(true)
		elif cur_page == 6:
			Data.intro_watched = true
			$IntroMusic.stop()
			get_tree().change_scene("res://src/Level/LevelHome.tscn")
		timer.start()


func _on_Timer_timeout():
	ok_next = true
