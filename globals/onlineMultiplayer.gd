extends Control

const MAX_CONNECTIONS = 2

var multiplayer_peer = ENetMultiplayerPeer.new()
const DEFAULT_PORT = 6000
const DEFAULT_IP   = "127.0.0.1"

var player

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func hostGame(port = null): #Creates a server on the provided port. If no port is provided, will use default port
	if !port:
		port = DEFAULT_PORT
	var error = multiplayer_peer.create_server(port)
	if error:
		return error
	multiplayer.multiplayer_peer = multiplayer_peer
	
func joinGame(ip = null, port = null): #Tries to join a server at the provided ip address and port. If either is not provided, will use defaults
	if !port:
		port = DEFAULT_PORT
		print("No port provided, using default of" + str(DEFAULT_PORT))
	else:
		port = str(port)
	if !ip:
		ip = DEFAULT_IP
	var error = multiplayer_peer.create_client(ip, port)
	if error:
		return error
	multiplayer.multiplayer_peer = multiplayer_peer

func _on_player_connected() -> void:
	if multiplayer.is_server():
		player = multiplayer.get_remote_sender_id()
	elif !multiplayer.is_server():
		pass
	pass

func _on_player_disconnected() -> void:
	player = null

func _on_connected_ok() -> void:
	pass

func _on_connected_fail() -> void:
	pass
	
func _on_server_disconnected() -> void:
	multiplayer.multiplayer_peer = null
	pass
	
