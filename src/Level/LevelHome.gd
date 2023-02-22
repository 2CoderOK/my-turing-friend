extends Node2D

const LIMIT_LEFT = -315
const LIMIT_TOP = -250
const LIMIT_RIGHT = 2955
const LIMIT_BOTTOM = 705

onready var nuts_text = $TunnelUI/Nuts
onready var engine_player = $Platforms/PlatformGear/AnimationPlayer
onready var lift_to_resources = $Platforms/LiftToResources/AnimationPlayer
onready var player = $Player
onready var _pause_menu = $UI/IngameMenu

onready var notifier_resource_level = $SwitchToResourcesLevel
onready var vault_warning_text_notify = $VaultWarningText
onready var resource_level_text = $ResourcesLevelText
onready var forge_text = $ForgeText

onready var _dialog_resource = Dialogic.start("resource_info")
onready var _dialog_forge = Dialogic.start("forge_gear")
onready var _dialog_nuts = Dialogic.start("need_nuts")
onready var _dialog_vault = Dialogic.start("walk_vault")
onready var _dialog_av = Dialogic.start("av")

var gear = null

func add_gear():
	var new_gear = preload("res://src/Actors/Gear.tscn").instance()
	new_gear.speed = Vector2(80, 100)
	new_gear.scale = Vector2(1.5, 1.5)
	new_gear.global_position = Vector2(-566, 488)

	new_gear.set_collision_layer_bit(0, false)
	new_gear.set_collision_layer_bit(5, true)
	new_gear.set_collision_mask_bit(3, true)
	new_gear.set_collision_mask_bit(4, true)
	new_gear.set_collision_mask_bit(6, true)
	new_gear.set_visible(true)
	new_gear.set_z_index(10)
	add_child(new_gear)

func _ready():
	engine_player.play("up")
	
	if Data.nuts > 0:
		notifier_resource_level.queue_free()
		lift_to_resources.play("down")
		player.global_position = Vector2(3904, -198)
		resource_level_text.queue_free()
	elif Data.forge_gear:
		$Platforms/LongLift.set_visible(false)
		$Platforms/LongLift.get_node("CollisionShape2D").disabled = true
		$Platforms/LongLift/AnimationPlayer.stop(false)
		player.global_position = Vector2(-120, 448)
		engine_player.play("down")
		var charge_dialog = Dialogic.start("charge_gear")
		add_child(charge_dialog)
		charge_dialog.connect("dialogic_signal", self, '_unpause_player')
	else:
		var intro_dialog = Dialogic.start("intro")
		add_child(intro_dialog)
		intro_dialog.connect("dialogic_signal", self, '_unpause_player')

	for child in get_children():
		if child is Player:
			var camera = child.get_node("Camera")
			camera.limit_bottom = LIMIT_BOTTOM
	if not Data.text_vault_shown:
		vault_warning_text_notify.set_visible(true)
	

func _process(delta):
	nuts_text.text = str(Data.nuts)

func buy_gear():
	if Data.nuts >= 30:
		Data.nuts -= 30
		engine_player.play("down")
		$Buttons/Button.randomize_buttons_and_arm(true)
		$Buttons/Button1.randomize_buttons_and_arm(true)
		$Buttons/Button2.randomize_buttons_and_arm(true)
		$Buttons/Button3.randomize_buttons_and_arm(true)
		$Buttons/Button4.randomize_buttons_and_arm(true)
		$Buttons/Button5.randomize_buttons_and_arm(true)
		$Buttons/Button6.randomize_buttons_and_arm(true)
		$Buttons/Button7.randomize_buttons_and_arm(true)
		$Buttons/Button8.randomize_buttons_and_arm(true)
		return true
	return false


func _unhandled_input(event):
	if event.is_action_pressed("toggle_pause"):
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			_pause_menu.open()
		else:
			_pause_menu.close()
		get_tree().set_input_as_handled()


func pause_long_lift():
	if gear and not gear._is_paused:
		$Platforms/LongLift.set_visible(false)
		$Platforms/LongLift/AnimationPlayer.stop(false)

func run_dialog(dialog):
	add_child(dialog)
	dialog.connect("dialogic_signal", self, '_unpause_player')
	$Player._is_paused = true
	$Player.force_idle()	

func _on_Area2DGearFinish_body_entered(body):
	var gear = body as Gear
	if gear:
		gear._is_paused = true
		gear.rolling_sound.stop()
		run_dialog(_dialog_av)

func _on_VisibilityNotifier2D_screen_entered():
	var player_area = $Player/Area2D
	player_area.set_monitorable(true)
	player_area.set_monitoring(true)
	$CanonFire/Area2Center.set_monitorable(false)
	$CanonFire/Area2Center.set_monitoring(false)
	$CanonFire/AnimationPlayer.play("on_full")
	$TunnelUI.set_visible(false)
	$UI/HeroProgressBar.set_visible(true)

func _on_VisibilityNotifier2D_screen_exited():
	$Canon/MissileTimer.stop()
	$CanonFire/AnimationPlayer.play("off")
	$CanonFire.sound_off()
	var player_area = $Player/Area2D
	player_area.set_monitorable(false)
	player_area.set_monitoring(false)
	$UI/HeroProgressBar.set_visible(false)
	$TunnelUI.set_visible(true)


func _on_SwitchToResourcesLevel_screen_entered():
	$Music.stop()
	get_tree().change_scene("res://src/Level/LevelResource.tscn")

func _unpause_player(param):
	$Player._is_paused = false
	if param == "forge":
		$Music.stop()
		get_tree().change_scene("res://src/Level/ForgeTutorial.tscn")
	elif param == "charge":
		add_gear()
	elif param == "av":
		$Music.stop()
		get_tree().change_scene("res://src/Level/TunnelTutorial.tscn")

func _on_VaultWarningText_screen_entered():
	vault_warning_text_notify.queue_free()
	run_dialog(_dialog_vault)

func _on_ResourcesLevelText_screen_entered():
	resource_level_text.queue_free()
	run_dialog(_dialog_resource)

func _on_ForgeText_screen_entered():
	if $ForgeText/ForgeTextTimer.is_stopped():
		$ForgeText/ForgeTextTimer.start()
		var dialog 
		if Data.nuts == 30:
			Data.nuts = 0
			forge_text.queue_free()
			run_dialog(_dialog_forge)
		else:
			run_dialog(_dialog_nuts)
