extends Control

signal scoreUpdate

var scoreText = []
var player = 1
var newHigh = false

func _ready() -> void:
	var highScoreFile = FileAccess.open("user://score.dat", FileAccess.WRITE)
	newHigh = false
	$multiplayerFinish.visible = false
	$singleplayerFinish.visible = false
	if OnlineMultiplayer.isMultiplayer:
		Score.scores.remove_at(2)
		Score.scores.remove_at(3)
		Score.scores.remove_at(4)
	if PlayerInfo.isModeMultiplayer:
		$multiplayerFinish.visible = true
		for val in Score.scores:
			scoreText.append("Player " + str(player) + ": $" + str(val*10))
			if Score.scores[player-1] > Score.highScore:
				Score.highScore = Score.scores[player-1]
				newHigh = true
				scoreUpdate.emit()
			player += 1
		$multiplayerFinish/scoreCard.text = "\n".join(scoreText)
		$multiplayerFinish/highScore.text = "High Score: $" + str(Score.highScore*10)
		if newHigh:
			highScoreFile.store_var(Score.highScore)
			highScoreFile.flush()
	elif not PlayerInfo.isModeMultiplayer:
		if Score.scores[0] > Score.highScore:
			Score.highScore = Score.scores[0]
			highScoreFile.store_var(Score.highScore)
			highScoreFile.flush()
		$singleplayerFinish.visible = true
		$singleplayerFinish/scoreCard.text = "Money: $" +str(Score.scores[0]*10)
		$singleplayerFinish/highScore.text = "High Score: $" + str(Score.highScore*10)
	
	highScoreFile.close()
		
#func _input(event: InputEvent) -> void:
	#if event is InputEventKey and event.keycode == KEY_SPACE and not event.is_echo():
		#newGame()

func newGame() -> void:
	Score.scores.clear()
	PlayerInfo.playerCount = 1
	get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")


func exitGame() -> void:
	get_tree().quit()
