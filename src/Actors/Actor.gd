class_name Actor
extends KinematicBody2D


export var speed = Vector2(150.0, 350.0)
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO
var _is_paused = false


func _physics_process(delta):
	if not _is_paused:
		_velocity.y += gravity * delta
