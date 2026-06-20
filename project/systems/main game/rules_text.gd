extends Control

func _ready() -> void:
	visible = false

func toggle_visibility() -> void:
	visible = !visible

func _on_button_pressed() -> void:
	toggle_visibility()

func _unhandled_input(event: InputEvent) -> void:
	@warning_ignore("unsafe_property_access")
	if event is InputEventKey and event.pressed:
		@warning_ignore("unsafe_property_access")
		if event.keycode == KEY_ESCAPE:
			toggle_visibility()
