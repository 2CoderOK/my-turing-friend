extends Node


var text_vault_shown = false

var health_max = 100
var health = 100

var shield_fire_max = 30
var shield_fire = 0

var shield_cold_max = 30
var shield_cold = 0

var shield_ammo_max = 30
var shield_ammo = 0

var intro_watched = false

var nuts = 0

var forge_gear = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func reset(forge = true) -> void:
	nuts = 0
	health = health_max
	shield_ammo = 0
	shield_cold = 0
	shield_fire = 0

func hit(damage) -> void:
	health -= damage
	if health <= 15:
		get_tree().change_scene("res://src/Main/Gameover.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
