extends CanvasLayer

var tweenIn: Tween
var tweenOut: Tween
var target_rotation = 0.0
var rotation_speed = 10.0


func _ready() -> void:
	rotation = -PI/2.0

func apply_bounce_rotation():
	show()
	if tweenOut:
		tweenOut.stop()
	tweenIn = create_tween().set_parallel()
	tweenIn.set_ease(Tween.EASE_IN_OUT)
	tweenIn.set_trans(Tween.TRANS_SPRING)
	tweenIn.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tweenIn.tween_property(self, "rotation", 0, 1)


func resume_game() -> void:
	Music.target_frequency = 20_000.0;
	get_tree().paused = false
	if tweenIn:
		tweenIn.stop()
	tweenOut = create_tween().set_parallel()
	tweenOut.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	tweenOut.tween_property(self, "rotation", -PI/2.0, 10.0/rotation_speed)
	await tweenOut.finished
	hide()

func _process(_delta: float) -> void:
	if tweenIn:
		tweenIn.set_speed_scale(1.0 / Engine.time_scale)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and get_tree().paused:
		resume_game()
		get_tree().get_root().set_input_as_handled()


func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	resume_game()


func _on_master_volume_value_changed(value: float) -> void:
	Music.set_master_volume(value)


func _on_music_volume_value_changed(value: float) -> void:
	Music.set_music_volume(value)


func _on_sfx_volume_value_changed(value: float) -> void:
	Music.set_sfx_volume(value)
