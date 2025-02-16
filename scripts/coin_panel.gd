extends CanvasLayer

@onready var points_label: Label = $Control/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/PointsLabel

func _ready():
	GameManager.connect("points_updated", _update_points_label)

func _update_points_label(new_count: int):
	points_label.text = str(new_count)
