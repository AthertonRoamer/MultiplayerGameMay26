extends Button

signal pressed_left_click
signal pressed_right_click

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_echo() and event.pressed:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			pressed_left_click.emit()
		elif event.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			pressed_right_click.emit()
