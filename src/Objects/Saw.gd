class_name Saw
extends KinematicBody2D


onready var player := $AnimationPlayer
onready var saw_sound := $SawSound
var rng = RandomNumberGenerator.new()
var sfx_position = null

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	player.play("run_left")
	player.seek(rng.randf_range(0, 4.1))
	saw_sound.set_pitch_scale(rng.randf_range(0.90, 1.10))


func _on_VisibilityEnabler2D_screen_entered():
	if sfx_position != null:
		saw_sound.play(sfx_position)
	else:
		saw_sound.play(player.get_current_animation_position())


func _on_VisibilityEnabler2D_screen_exited():
	sfx_position = saw_sound.get_playback_position()
	saw_sound.stop()
