extends Control

var scoreText = []
var player = 1

func _ready() -> void:
	$multiplayerFinish.visible = false
	$singleplayerFinish.visible = false
	if PlayerInfo.isModeMultiplayer:
		$multiplayerFinish.visible = true
		for val in Score.scores:
			scoreText.append("Player " + str(player) + ": $" + str(val*10))
			if Score.scores[player-1] > Score.highScore:
				Score.highScore = Score.scores[player-1]
			player += 1
		$multiplayerFinish/scoreCard.text = "\n".join(scoreText)
		$multiplayerFinish/highScore.text = "High Score: $" + str(Score.highScore*10)
		FileSysUtil.save_to_file("High Score: $" + str(Score.highScore*10), "user://highScores.dat")
	elif not PlayerInfo.isModeMultiplayer:
		if Score.scores[0] > Score.highScore:
			Score.highScore = Score.scores[0]
		$singleplayerFinish.visible = true
		$singleplayerFinish/scoreCard.text = "Money: $" +str(Score.scores[0]*10)
		$singleplayerFinish/highScore.text = "High Score: $" + str(Score.highScore*10)
		


func newGame() -> void:
	Score.scores.clear()
	PlayerInfo.playerCount = 1
	get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
