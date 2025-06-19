extends Control


func showDifficulty() -> void:
	visible = true

func easy() -> void:
	PlayerInfo.difficulty = 0
	visible = false

func medium() -> void:
	PlayerInfo.difficulty = 1
	visible = false

func hard() -> void:
	PlayerInfo.difficulty = 2
	visible = false
