extends Control
var port = 0
var ip = ""

func _ready() -> void:
	visible = false


func portVisibility(toggled_on: bool) -> void:
	$ipAddress/port.visible = toggled_on

func connectSelected() -> void:
	port = int($ipAddress/port.text)
	ip = $ipAddress.text
	OnlineMultiplayer.joinGame(ip, port)


func hostSelected() -> void:
	port = int($ipAddress/port.text)
	OnlineMultiplayer.hostGame(port)
