extends Control

func _ready() -> void:
	visible = true
	Tutorial.game_start.connect(perish)

func _on_button_pressed() -> void:
	pass

func perish() -> void:
	queue_free()
