extends CanvasLayer

@onready var coin_label: Label = $Control/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/CoinLabel

func _ready():
	GameManager.connect("coins_updated", _update_coin_label)

func _update_coin_label(new_count: int):
	coin_label.text = str(new_count)
