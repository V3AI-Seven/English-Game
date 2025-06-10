extends Control

var scoreText = []
var player = 1

func _ready() -> void:
	for val in Score.scores:
		scoreText.append("Player " + str(player) + ": " + str(val))
		player += 1
	$scoreCard.text = "\n".join(scoreText)
