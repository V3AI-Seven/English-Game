extends Control

var scoreText = []
var player = 1

func _ready() -> void:
	if PlayerInfo.isModeMultiplayer:
		$multiplayerFinish.visible = true
		for val in Score.scores:
			scoreText.append("Player " + str(player) + ": $" + str(val*10))
			if Score.scores[player] > Score.highScore:
				Score.highScore = Score.Scores[player]
			player += 1
		$multiplayerFinish/scoreCard.text = "\n".join(scoreText)
	elif not PlayerInfo.isModeMultiplayer:
		if Score.scores[0] > Score.highScore:
			Score.highScore = Score.Scores[0]
		$singleplayerFinish.visible = true
		$singleplayerFinish/scoreCard.text = "Money: $" +str(Score.scores[0]*10)
		


func newGame() -> void:
	Score.scores.clear()
	PlayerInfo.playerCount = 1
	get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
