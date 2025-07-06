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

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F4 and !event.is_echo(): #Test popup
			GlobalFunctions.popup({
				"name":"Test Popup",
				"content":"Test popup text"
			})
func hostGame(port = null): #Creates a server on the provided port. If no port is provided, will use default port
	if port == null:
		port = DEFAULT_PORT
		print("No port provided, using default of " + str(DEFAULT_PORT))
	var error = multiplayer_peer.create_server(int(port), MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = multiplayer_peer
	
func joinGame(ip = null, port = null): #Tries to join a server at the provided ip address and port. If either is not provided, will use defaults
	print("Attempting to connect to " + str(ip) + ":" + str(port))
	if port == null:
		port = DEFAULT_PORT
		print("No port provided, using default of " + str(DEFAULT_PORT))
	if ip == null:
		ip = DEFAULT_IP
		print("No IP provided, using local IP")
	var error = multiplayer_peer.create_client(ip, int(port))
	if error:
		printerr(error)
		return error
	multiplayer.multiplayer_peer = multiplayer_peer

func _on_player_connected() -> void:
	if multiplayer.is_server():
		player = multiplayer.get_remote_sender_id()
		print("Connected player ID: " + str(player))
	elif !multiplayer.is_server():
		pass
	pass

func _on_player_disconnected() -> void:
	if multiplayer.is_server():
		player = null
		print("Player disconnected")
	elif !multiplayer.is_server():
		pass
	pass
	

func _on_connected_ok() -> void:
	if multiplayer.is_server():
		pass
	elif !multiplayer.is_server():
		print("Connected to server")
	pass

func _on_connected_fail() -> void:
	if multiplayer.is_server():
		pass
	elif !multiplayer.is_server():
		printerr("Failed to connect to server")
	pass
	
func _on_server_disconnected() -> void:
	if multiplayer.is_server():
		pass
	elif !multiplayer.is_server():
		multiplayer.multiplayer_peer = null
		printerr("Lost connection to server")
	
