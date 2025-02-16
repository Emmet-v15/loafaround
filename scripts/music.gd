extends AudioStreamPlayer2D

var low_pass_filter = AudioEffectLowPassFilter.new()
var target_frequency = 20000.0
var frequency_change_speed = 10


func set_master_volume(volume_dba: float) -> void:
	AudioServer.set_bus_volume_db(0, volume_dba)


func set_music_volume(volume_dba: float) -> void:
	AudioServer.set_bus_volume_db(1, volume_dba)


func set_sfx_volume(volume_dba: float) -> void:
	AudioServer.set_bus_volume_db(2, volume_dba)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	low_pass_filter.cutoff_hz = target_frequency
	low_pass_filter.resonance = 1
	low_pass_filter.db = low_pass_filter.FILTER_24DB
	AudioServer.add_bus_effect(1, low_pass_filter)


func _process(delta: float) -> void:
	low_pass_filter.cutoff_hz = lerp(low_pass_filter.cutoff_hz, target_frequency, frequency_change_speed * delta)
