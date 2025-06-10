extends Control

var player = 0

func _ready() -> void:
	visible = false


func playerFail() -> void:
	visible = true
	$scoreCard.text = "Score: " +str(Score.scores[player]) + "\n" + "Press Space for next player"


func playerReset() -> void:
	visible = false
