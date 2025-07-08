extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and !event.is_echo():
			OnlineMultiplayer.multiDisconnect()
			get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
