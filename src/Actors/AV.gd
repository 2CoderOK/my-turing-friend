class_name AV
extends Actor


enum ShieldDir {
	RIGHT,
	RIGHT_TOP,
	TOP,
	LEFT_TOP
} 

var shield_dir = ShieldDir.RIGHT
var is_hit = false
var is_beam_hit = false
var is_beam_shiled_hit = false
var is_tutorial = false
var first_hit = false


func _ready():
	_velocity.x = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Data.shield_cold <= 0 ||  Data.shield_fire <= 0 || Data.shield_ammo <= 0:
		if not is_tutorial and first_hit:
			get_tree().change_scene("res://src/Main/Gameover.tscn")
	if is_beam_hit and not is_beam_shiled_hit || is_hit:
		if self.visible:
			self.set_visible(false)
		else:
			self.set_visible(true)
	else:
		self.set_visible(true)

	move_and_slide(_velocity)
	if not $ShieldAnimationPlayer.is_playing():
		if int(Input.get_action_strength("ui_right")) > 0 || int(Input.get_action_strength("ui_down")) > 0:
			move_shield(ShieldDir.RIGHT)
		elif int(Input.get_action_strength("ui_up")) > 0:
			move_shield(ShieldDir.TOP)
		elif int(Input.get_action_strength("ui_left")) > 0:
			move_shield(ShieldDir.LEFT_TOP)

func stop():
	$AnimationPlayer.stop(false)
	$ShieldAnimationPlayer.stop(false)
	_velocity.x = 0


func move_shield(dir):
	if dir != shield_dir:
		if dir == ShieldDir.RIGHT:
			if shield_dir == ShieldDir.RIGHT_TOP:
				$ShieldAnimationPlayer.play("rt-right")
				shield_dir = ShieldDir.RIGHT
			elif shield_dir == ShieldDir.TOP:
				$ShieldAnimationPlayer.play("top-rt")
				shield_dir = ShieldDir.RIGHT_TOP
			elif shield_dir == ShieldDir.LEFT_TOP:
				$ShieldAnimationPlayer.play("lt-top")
				shield_dir = ShieldDir.TOP
		elif dir == ShieldDir.TOP:
			if shield_dir == ShieldDir.RIGHT_TOP:
				$ShieldAnimationPlayer.play("rt-top")
				shield_dir = ShieldDir.TOP
			elif shield_dir == ShieldDir.RIGHT:
				$ShieldAnimationPlayer.play("right-rt")
				shield_dir = ShieldDir.RIGHT_TOP
			elif shield_dir == ShieldDir.LEFT_TOP:
				$ShieldAnimationPlayer.play("lt-top")
				shield_dir = ShieldDir.TOP
		elif dir == ShieldDir.LEFT_TOP:
			if shield_dir == ShieldDir.RIGHT:
				$ShieldAnimationPlayer.play("right-rt")
				shield_dir = ShieldDir.RIGHT_TOP
			elif shield_dir == ShieldDir.RIGHT_TOP:
				$ShieldAnimationPlayer.play("rt-top")
				shield_dir = ShieldDir.TOP
			elif shield_dir == ShieldDir.TOP:
				$ShieldAnimationPlayer.play("top-lt")
				shield_dir = ShieldDir.LEFT_TOP


func _on_ShiledArea2D2_body_entered(body):
	if body as Missile:
		body.queue_free()
		print("shiled missile hit")


func _on_Area2D_body_entered(body):
	print("player hit")
	var missile = body as Missile
	if missile:
		Data.shield_ammo -= 1
		is_hit = true
		first_hit = true
		$MissileHit.start()
		missile.queue_free()

func _on_Area2D_area_entered(area):
	print("player hit")
	if area.is_in_group("fire"):
		is_beam_hit = true
		first_hit = true
		Data.shield_fire -= 1
		$FireBeamHit.start()
		print("player fire hit")
	elif area.is_in_group("cold"):
		is_beam_hit = true
		first_hit = true
		Data.shield_cold -= 1
		$ColdBeamHit.start()
		print("player cold hit")


func _on_Area2D_area_exited(area):
	print("player unhit")
	if area.is_in_group("fire"):
		is_beam_hit = false
		print("player fire stop")
	elif area.is_in_group("cold"):
		is_beam_hit = false
		print("player cold stop")


func _on_ShiledArea2D2_area_entered(area):
	print("shiled hit")
	if area.is_in_group("fire"):
		is_beam_shiled_hit = true
		area.get_parent().get_node("AnimationPlayer").play("on")
		print("shield fire hit")
	if area.is_in_group("cold"):
		is_beam_shiled_hit = true
		area.get_parent().get_node("AnimationPlayer").play("on")
		print("shield cold hit")


func _on_ShiledArea2D2_area_exited(area):
	print("shiled unhit")
	if area.is_in_group("fire"):
		is_beam_shiled_hit = false
		area.get_parent().get_node("AnimationPlayer").play("on_full")
		print("shield fire stop")
	elif area.is_in_group("cold"):
		is_beam_shiled_hit = false
		area.get_parent().get_node("AnimationPlayer").play("on_full")
		print("shield cold stop")


func _on_MissileHit_timeout():
	is_hit = false


func _on_ColdBeamHit_timeout():
	if is_beam_hit:
		Data.shield_cold -= 1
		$ColdBeamHit.start()


func _on_FireBeamHit_timeout():
	if is_beam_hit:
		Data.shield_fire -= 1
		$FireBeamHit.start()
