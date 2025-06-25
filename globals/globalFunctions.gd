extends Node
func _notification(notification):
	if notification == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior
