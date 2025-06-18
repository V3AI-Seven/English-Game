extends Control

var players = 0

func _ready() -> void:
	pass


func playerCountConfirmed() -> void:
	players = $playerCount.value
	PlayerInfo.playerCount = players
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	


func multiplayerSelect() -> void:
	visible = true
