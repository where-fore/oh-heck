extends Control

func _ready() -> void:
	visible = true
	Tutorial.game_start.connect(perish)

func perish() -> void:
	queue_free()
