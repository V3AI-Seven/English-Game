extends Control
var port = 0
var ip = ""

func _ready() -> void:
	visible = false


func portVisibility(toggled_on: bool) -> void:
	$ipAddress/port.visible = toggled_on

func connectSelected() -> void:
	Score.scores.append(0)
	Score.scores.append(null)
	port = int($ipAddress/port.text)
	ip = $ipAddress.text
	OnlineMultiplayer.joinGame(ip, port)


func hostSelected() -> void:
	Score.scores.append(0)
	Score.scores.append(null)
	port = int($ipAddress/port.text)
	OnlineMultiplayer.hostGame(port)
