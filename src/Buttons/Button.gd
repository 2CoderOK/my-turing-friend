class_name PushButton
extends KinematicBody2D


# Button types are: "empty", "fire", "cold" and "ammo

enum State {
	ARMED,
	DOWN,
	WORKING,
	UP,
	DISABLED
}
var button_states = []
var button_types = []
var activated_canon = null
var is_hitting = ""
var last_hit_msec = 0
const HIT_TIME = 90

func _init():
	randomize_buttons_and_arm()

func _ready():
	pass

func is_down() -> bool:
	var down = true
	for bs in button_states:
		if bs != State.DISABLED:
			down = false
	return down

func randomize_buttons_and_arm(anim = false):
	activated_canon = null
	var types = ["ammo", "fire", "cold"]
	randomize()
	types.shuffle()
	button_states = []
	for i in range(0,3):
		button_types.append(types[i])
		button_states.append(State.ARMED)
	print(button_types)
	if anim:
		get_node("AnimationPlayer_1").play("up")
		get_node("AnimatedSprite_1").play(button_types[0])
		get_node("AnimationPlayer_2").play("up")
		get_node("AnimatedSprite_2").play(button_types[1])
		get_node("AnimationPlayer_3").play("up")		
		get_node("AnimatedSprite_3").play(button_types[2])

func _process(delta):
	if is_hitting != "":
		process_hit()
		return
	var disable_buttons = false
	var i = 0
	for bs in button_states:
		i += 1
		if bs == State.ARMED and activated_canon == null:
			if get_node("RayCast2D_%d" % i).is_colliding() || get_node("RayCast2D_%d_2" % i).is_colliding():
				get_node("AnimationPlayer_%d" % i).play("down")
				print("button " + str(i) + " type %s" % button_types[i - 1])
				activated_canon = button_types[i - 1]
				button_states[i - 1] = State.DOWN
				disable_buttons = true				
				break
		
	if disable_buttons:
		i = 0
		for bs in button_states:
			if bs == State.ARMED:
				bs = State.DISABLED
				get_node("AnimationPlayer_%d" % (i + 1)).play("down")
				get_node("AnimatedSprite_%d" % (i + 1)).play("empty")
			i += 1

func process_hit():
	var msec = OS.get_ticks_msec()
	if msec - last_hit_msec >= HIT_TIME:
		last_hit_msec = msec
		if is_hitting == "ammo":
			Data.shield_ammo += 1
		elif is_hitting == "fire":
			Data.shield_fire += 1
		elif is_hitting == "cold":
			Data.shield_cold += 1

func _on_AnimationPlayer_1_ready():
	$AnimatedSprite_1.play(button_types[0])

func _on_AnimationPlayer_2_ready():
	$AnimatedSprite_2.play(button_types[1])

func _on_AnimationPlayer_3_ready():
	$AnimatedSprite_3.play(button_types[2])

func _on_AnimationPlayer_3_animation_finished(anim_name):
	if anim_name == "down":
		$AnimatedSprite_3.play("empty")
		button_states[2] = State.DISABLED
		if activated_canon == button_types[2]:
			start_canon(button_types[2])

func _on_AnimationPlayer_2_animation_finished(anim_name):
	if anim_name == "down":
		$AnimatedSprite_2.play("empty")
		button_states[1] = State.DISABLED
		if activated_canon == button_types[1]:
			start_canon(button_types[1])

func _on_AnimationPlayer_1_animation_finished(anim_name):
	if anim_name == "down":
		$AnimatedSprite_1.play("empty")
		button_states[0] = State.DISABLED
		if activated_canon == button_types[0]:
			start_canon(button_types[0])

func sound_off():
	$BeamSound.stop()

func start_canon(type):
	$BeamSound.play()
	print("start_cannon " + type)
	if type == "fire":
		$CanonAnimationPlayer_Fire.play("on")
	elif type == "ammo":
		$CanonAnimationPlayer_Ammo.play("on")
	elif type == "cold":
		$CanonAnimationPlayer_Cold.play("on")


func _on_Area2DFire_body_entered(body):
	(body as Gear).hit(true)
	is_hitting = "fire"
	print("fire body enter")
	

func _on_Area2DFire_body_exited(body):
	(body as Gear).hit(false)
	is_hitting = ""
	print("fire body exit")


func _on_Area2DAmmo_body_entered(body):
	(body as Gear).hit(true)
	is_hitting = "ammo"
	print("ammo body enter")


func _on_Area2DAmmo_body_exited(body):
	(body as Gear).hit(false)
	is_hitting = ""
	print("ammo body exit")


func _on_Area2DCold_body_entered(body):
	(body as Gear).hit(true)
	is_hitting = "cold"
	print("cold body enter")


func _on_Area2DCold_body_exited(body):
	(body as Gear).hit(false)
	is_hitting = ""
	print("cold body exit")
