class_name HeroProgressBar
extends TextureProgress

onready var blink_timer = null

func _ready():
	set_max(Data.health_max)
	set_value(Data.health)
	blink_timer = Timer.new()
	blink_timer.wait_time = 0.05
	blink_timer.one_shot = true
	add_child(blink_timer)

func update_bars():
	$AmmoBar.set_value(Data.shield_ammo)
	$FireBar.set_value(Data.shield_fire)
	$ColdBar.set_value(Data.shield_cold)

func blink():
	if Data.health < 34:
		if blink_timer.is_stopped():
			blink_timer.start()
			if value == 0:
				set_value(Data.health)
			else:
				set_value(0)
	else:
		set_value(Data.health)


func _process(delta):
	blink()

