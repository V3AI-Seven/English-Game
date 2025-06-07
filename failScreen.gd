extends Control

func _ready() -> void:
	visible = false


func playerFail() -> void:
	visible = true


func playerReset() -> void:
	visible = false
