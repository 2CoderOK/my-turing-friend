class_name TunnelUI
extends CanvasLayer


var ammo_blink = false
var fire_blink = false
var cold_blink = false


func _ready():
	$AmmoBar.set_max(Data.shield_ammo_max)
	$FireBar.set_max(Data.shield_fire_max)	
	$ColdBar.set_max(Data.shield_cold_max)
	
	update_bars()

func update_bars():
	$AmmoBar.set_value(Data.shield_ammo)
	$FireBar.set_value(Data.shield_fire)
	$ColdBar.set_value(Data.shield_cold)

func blink(bar, is_blink, max_value, value):
	if is_blink:
		is_blink = false
		bar.set_value(0)
	else:
		if value < max_value * 0.1:
			is_blink = true
	return is_blink


func _process(delta):	
	update_bars()
	ammo_blink = blink($AmmoBar, ammo_blink, Data.shield_ammo_max, Data.shield_ammo)
	fire_blink = blink($FireBar, fire_blink, Data.shield_fire_max, Data.shield_fire)
	cold_blink = blink($ColdBar, cold_blink, Data.shield_cold_max, Data.shield_cold)

