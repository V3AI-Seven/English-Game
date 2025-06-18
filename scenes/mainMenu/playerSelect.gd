extends Control

var players = 0

func _ready() -> void:
	pass


func playerCountConfirmed() -> void:
	players = $playerCount.value
	Players.playerCount = players
	get_tree().change_scene_to_file("res://game.tscn")
	
