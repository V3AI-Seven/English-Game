extends Node

const MAX_CONNECTIONS = 2

var multiplayer_peer = ENetMultiplayerPeer.new()
const DEFAULT_PORT = 25565
const DEFAULT_IP   = "127.0.0.1"

var isMultiplayer = false
var player
var connectionIP = ""
var connectionPort = 0 

#Multiplayer setup stuff

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
			
#Custom functions from here

func hostGame(port = null): #Creates a server on the provided port. If no port is provided, will use default port
	if isMultiplayer:
		GlobalFunctions.popup({
			"name":"Failed to host or join",
			"content":"You are already hosting or connected!"
		})
		return "Already hosting"

	if port == null or port == 0:
		port = DEFAULT_PORT
		print("No port provided, using default of " + str(DEFAULT_PORT))
	print("Attempting to host on port " + str(port))
	connectionPort = port
	
	#Starting server
	var error = multiplayer_peer.create_server(int(port), MAX_CONNECTIONS)
	if error:
		GlobalFunctions.popup({
			"name":"Failed to host",
			"content":"Something went wrong!"
		})
		printerr(str(error))
		return error
	multiplayer.multiplayer_peer = multiplayer_peer
	isMultiplayer = true
	get_tree().change_scene_to_file("res://scenes/connectWaiting/connectWaiting.tscn")
	
func joinGame(ip = null, port = null): #Tries to join a server at the provided ip address and port. If either is not provided, will use defaults
	if isMultiplayer:
		GlobalFunctions.popup({
			"name":"Failed to host or join",
			"content":"You are already hosting or connected!"
		})
		return "Already hosting"
	if port == null or port == 0:
		port = DEFAULT_PORT
		print("No port provided, using default of " + str(DEFAULT_PORT))
	if ip == null or ip == "":
		ip = DEFAULT_IP
		print("No IP provided, using local IP")
	print("Attempting to connect to " + str(ip) + ":" + str(port))
	connectionPort = port
	connectionIP = ip
	
	get_tree().change_scene_to_file("res://scenes/connectWaiting/connectWaiting.tscn")
	
	#Connecting to server
	var error = multiplayer_peer.create_client(ip, int(port))
	if error:
		GlobalFunctions.popup({
			"name":"Failed to join",
			"content":"Something went wrong!"
		})
		printerr(error)
		return error
	multiplayer.multiplayer_peer = multiplayer_peer
	isMultiplayer = true
	

func multiDisconnect() -> void:
	if isMultiplayer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		isMultiplayer = false
	else:
		printerr("Tried to disconnect from server/client when multiplayer not running!")
		GlobalFunctions.popup({
			"name":"Cannot disconnect",
			"content":"Cannot disconnect from server if not connected/running"
		})

#Multiplayer API functions from here

func _on_player_connected(_id) -> void:
	if multiplayer.is_server():
		player = multiplayer.get_remote_sender_id()
		print("Connected player ID: " + str(player))
		rpc("startGame")
	elif !multiplayer.is_server():
		pass
	pass

func _on_player_disconnected(_id) -> void:
	if multiplayer.is_server():
		player = null
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		print("Player disconnected")
		get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
		GlobalFunctions.popup({
			"name":"Player left",
			"content":"Other player left!"
		})
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
		printerr("The API says you failed to connect to the server, but also that you are the server!")
	elif !multiplayer.is_server():
		GlobalFunctions.popup({
			"name":"Connection Failed",
			"content":"Failed to connect to the server at " + str(connectionIP) + ":" + str(connectionPort)
		})
		printerr("Failed to connect to server")

	
func _on_server_disconnected() -> void:
	if multiplayer.is_server():
		printerr("The API says that you lost connection to the server, but also that you are the server!")
		pass
	elif !multiplayer.is_server():
		get_tree().change_scene_to_file("res://scenes/mainMenu/mainMenu.tscn")
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		GlobalFunctions.popup({
			"name":"Lost Connection",
			"content":"You lost connection to the host."
		})
		printerr("Lost connection to server!")
		
#RPC functions from here

@rpc("authority","call_local","reliable")
func startGame(): #Starts the game for all clients
	print("Starting game")
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
