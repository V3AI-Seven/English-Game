extends Control

const MAX_CONNECTIONS = 2

var multiplayer_peer = ENetMultiplayerPeer.new()
var port = 6000
var ip  = "127.0.0.1"

var player

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func portVisibility(toggled_on: bool) -> void: #Toggles the visibility of the port selector, based on the switch
	if toggled_on:
		$ipAddress/port.visible = true
	elif !toggled_on:
		$ipAddress/port.visible = false

func _on_player_connected() -> void:
	pass

func _on_player_disconnected() -> void:
	pass

func _on_connected_ok() -> void:
	pass

func _on_connected_fail() -> void:
	pass
	
func _on_server_disconnected() -> void:
	pass
