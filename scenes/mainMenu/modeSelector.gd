extends Control

func _ready() -> void:
	visible = true

func multiplayer() -> void:
	PlayerInfo.isModeMultiplayer = true
	visible = false


func singleplayer() -> void:
	PlayerInfo.isModeMultiplayer = false
	visible = false
	PlayerInfo.playerCount = 1
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	
func backModeSelector() -> void:
	visible = true
