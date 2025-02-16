extends Node

var coin_panel: CanvasLayer
var pause_menu: CanvasLayer

var target_time_scale = 1.0
var pause_speed = 10.

func _ready():
	coin_panel = preload("res://scenes/coin_panel.tscn").instantiate()
	pause_menu = preload("res://scenes/pause_menu.tscn").instantiate()
	add_child(coin_panel)
	add_child(pause_menu)
	pause_menu.hide()

	
func _input(event):
	if event.is_action_pressed("ui_cancel") and not get_tree().paused:
		Music.target_frequency = 200.0	
		pause_menu.show()
		pause_menu.apply_bounce_rotation()
		target_time_scale = 0.0
		while !Utils.approximately_equal(Engine.time_scale, 0.0, 0.05):
			await get_tree().process_frame		
		target_time_scale = 1.0
		get_tree().paused = true
		get_tree().get_root().set_input_as_handled()


func _process(delta: float) -> void:
	Engine.time_scale = lerp(Engine.time_scale, target_time_scale, pause_speed * delta)
