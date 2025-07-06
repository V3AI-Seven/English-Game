extends Control
signal difficultyChosen

func _ready() -> void:
	if OnlineMultiplayer.isMultiplayer:
		if multiplayer.is_server():
			PlayerInfo.selectingDifficulty = true
			visible = true
		else:
			PlayerInfo.selectingDifficulty = true
			visible = false

func showDifficulty() -> void:
	PlayerInfo.selectingDifficulty = true
	visible = true

func easy() -> void:
	PlayerInfo.difficulty = 0
	print("Player chose easy")
	difficultyChosen.emit()
	visible = false

func medium() -> void:
	PlayerInfo.difficulty = 1
	print("Player chose medium")
	difficultyChosen.emit()
	visible = false

func hard() -> void:
	PlayerInfo.difficulty = 2
	print("Player chose hard")
	difficultyChosen.emit()
	visible = false
