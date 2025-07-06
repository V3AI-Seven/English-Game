extends Node

var infoPopup = preload("res://scenes/serverInfoPopup/serverInfoPopup.tscn")

func _notification(notificaton):
	if notificaton == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior

func popup(data: Dictionary): #Creates a popup with a custom title and text.
	var instance = infoPopup.instantiate()
	add_child(instance)
	var popupText = instance.get_node("text")
	if data.name:
		instance.title = data.name
	if data.content:
		popupText.text = data.content
	instance.visible = true
	instance.popup_centered()
