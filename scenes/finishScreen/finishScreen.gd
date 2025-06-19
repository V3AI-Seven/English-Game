extends Control

var scoreText = []
var player = 1
var newHigh = false

func _ready() -> void:
	var highScoreFile = FileAccess.open("user://score.dat", FileAccess.WRITE)
	var newHigh = false
	$multiplayerFinish.visible = false
	$singleplayerFinish.visible = false
	if PlayerInfo.isModeMultiplayer:
		$multiplayerFinish.visible = true
		for val in Score.scores:
			scoreText.append("Player " + str(player) + ": $" + str(val*10))
			if Score.scores[player-1] > Score.highScore:
				Score.highScore = Score.scores[player-1]
				newHigh = true
			player += 1
		$multiplayerFinish/scoreCard.text = "\n".join(scoreText)
		$multiplayerFinish/highScore.text = "High Score: $" + str(Score.highScore*10)
		if newHigh:
			highScoreFile.store_var(Score.highScore)
	elif not PlayerInfo.isModeMultiplayer:
		if Score.scores[0] > Score.highScore:
			Score.highScore = Score.scores[0]
			highScoreFile.store_var(Score.highScore)
		$singleplayerFinish.visible = true
		$singleplayerFinish/scoreCard.text = "Money: $" +str(Score.scores[0]*10)
		$singleplayerFinish/highScore.text = "High Score: $" + str(Score.highScore*10)
		


func newGame() -> void:
	Score.scores.clear()
	PlayerInfo.playerCount = 1
	get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
