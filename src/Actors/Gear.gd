class_name Gear
extends KinematicBody2D

export var speed = Vector2(150.0, 350.0)
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")
onready var rolling_sound = $RollingSound
onready var sprite = $Sprite

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO
var _is_paused = false

enum State {
	WAITING,
	ROLLING,
}

var hit_state = false

func _ready():
	_velocity.x = 70
	_velocity.y = 70
	

func hit(state):
	hit_state = state
	sprite.set_visible(not hit_state)
	sprite.set_visible(true)

func push(velocity: Vector2) -> void:
	if velocity.y != 0 || velocity.x != 0:
		_velocity = move_and_slide(0.50 * velocity)

func _physics_process(_delta):
	if not _is_paused:
		_velocity.y += gravity * _delta
		if hit_state:
			sprite.set_visible(not sprite.visible)

		move_and_slide(_velocity)
		# DO THIS ONLY WE ARE MOVING
		if _velocity.x > 0 and not rolling_sound.is_playing():
			rolling_sound.play()
		sprite.rotate(_velocity.x/10 * _delta)
