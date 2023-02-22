class_name Player
extends Actor


const FLOOR_DETECT_DISTANCE = 20.0
export var push_speed := 125.0


onready var platform_detector = $PlatformDetector
onready var sound_jump = $JumpSound
onready var sound_fall = $FallSound
onready var sound_hit = $HitSound

var perv_animation = ""
var is_hit = false

func _ready():
	pass


func _process(delta):
	if is_hit:
		$SpriteAnim.set_visible(not $SpriteAnim.visible)

func _physics_process(_delta):
	if _is_paused:
		return
	var motion : = Vector2()
	motion.x = int(Input.get_action_strength("ui_right")) - int(Input.get_action_strength("ui_up"))

	if Input.is_action_just_pressed("jump") and is_on_floor():
		sound_jump.play()

	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("jump") and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.ZERO
	if direction.y == 0.0:
		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)

	if get_slide_count() > 0:
		check_saw_collision(motion)
		#check_gear_collision(motion)

	if direction.x != 0:
		if direction.x > 0:
			$SpriteAnim.flip_h = false
		else:
			$SpriteAnim.flip_h = true

	var animation = get_new_animation()
	if animation != $SpriteAnim.animation:
		$SpriteAnim.play(animation)

func force_idle():
	_velocity.x = 0
	_velocity.y = 0
	var animation = get_new_animation()
	if animation != $SpriteAnim.animation:
		$SpriteAnim.play(animation)

func check_saw_collision(motion: Vector2) -> void:
	var saw := get_slide_collision(0).collider as Saw
	if saw:
		if not is_hit:
			Data.hit(17)
			hit()

func check_gear_collision(motion: Vector2) -> void:
	if abs(motion.x) + abs(motion.y) > 1:
		return
	var gear := get_slide_collision(0).collider as Gear
	if gear:
		gear.push(push_speed * motion)

func get_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1 if is_on_floor() and Input.is_action_just_pressed("jump") else 0
	)


func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y *= 0.6
	return velocity


func get_new_animation():
	var animation_new = ""
	if is_on_floor():
		if perv_animation == "falling" and not sound_fall.is_playing():
			sound_fall.play()
		if abs(_velocity.x) > 0.1:
			animation_new = "run"
		else:
			animation_new = "idle"
	else:
		if _velocity.y > 0:
			animation_new = "falling"
		else:
			animation_new = "jumping"
	perv_animation = animation_new
	return animation_new


func _on_Area2D_area_entered(area):
	var cannon_fire := area.get_parent() as CanonFire
	if cannon_fire:
		Data.hit(100)

func hit():
	is_hit = true
	if not sound_hit.is_playing():
		sound_hit.play()
	if not $Hit.is_stopped():
		$Hit.stop()
	$Hit.start()

func _on_Hit_timeout():
	is_hit = false
	$SpriteAnim.set_visible(true)
