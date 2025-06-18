extends Control

var scoreText = []
var player = 1

func _ready() -> void:
	for val in Score.scores:
		scoreText.append("Player " + str(player) + ": $" + str(val*10))
		player += 1
	$scoreCard.text = "\n".join(scoreText)


func newGame() -> void:
	Score.scores.clear()
	PlayerInfo.playerCount = 1
	get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
