extends Control

var players = 0
signal playerCount

func _ready() -> void:
	pass


func playerCountConfirmed() -> void:
	visible = false
	players = $playerCount.value
