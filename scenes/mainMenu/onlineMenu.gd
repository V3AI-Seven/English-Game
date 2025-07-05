extends Control
var port = 0
var ip = ""


func portVisibility(toggled_on: bool) -> void:
	$ipAddress/port.visible = toggled_on

func connectSelected() -> void:
	port = $ipAddress/port.text
	ip = $ipAddress.text
	OnlineMultiplayer.joinGame(ip, port)


func hostSelected() -> void:
	port = $ipAddress/port.text
	OnlineMultiplayer.hostGame(port)
