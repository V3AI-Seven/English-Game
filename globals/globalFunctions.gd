extends Node
func _notification(notificaton):
	if notificaton == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior
