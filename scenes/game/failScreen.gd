extends Control

var player = 0

func _ready() -> void:
	visible = false
	player = 0


func playerFail() -> void:
	visible = true
	$scoreCard.text = "Money: $" +str(Score.scores[player]*10) + "\n" + "Press space for next player"
	player += 1


func playerReset() -> void:
	visible = false
