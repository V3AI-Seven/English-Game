extends Control

var player = 0

func _ready() -> void:
	visible = false
	var player = 0


func playerFail() -> void:
	visible = true
	$scoreCard.text = "Score: " +str(Score.scores[player]) + "\n" + "Press Space for next player"
	player += 1


func playerReset() -> void:
	visible = false
