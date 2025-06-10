extends Control

var players = 0
signal playerCount(players:int)

func _ready() -> void:
	pass


func playerCountConfirmed() -> void:
	visible = false
	players = $playerCount.value
	playerCount.emit(players)
