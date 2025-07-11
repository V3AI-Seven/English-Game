extends Control

var players = 0

func _ready() -> void:
	visible = false


func playerCountConfirmed() -> void:
	players = $local/playerCount.value
	PlayerInfo.playerCount = players
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")

func multiplayerSelect() -> void:
	$online.visible = false
	$local.visible = false
	$onlineChoice.visible = true
	visible = true
	PlayerInfo.isModeMultiplayer = true


func localMultiplayer() -> void:
	PlayerInfo.isModeMultiplayer = true
	$onlineChoice.visible = false
	$local.visible = true


func onlineMultiplayer() -> void:
	PlayerInfo.isModeMultiplayer = true
	$onlineChoice.visible = false
	$online.visible = true

func backModeSelector() -> void:
	visible = false
	$online.visible = false
	$local.visible = false
	$onlineChoice.visible = true
