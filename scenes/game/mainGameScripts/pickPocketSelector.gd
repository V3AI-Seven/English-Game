extends Node2D

signal speedChange(speed: int)
signal successSig
signal failSig
signal resetSig
signal difficulty
signal onlineOtherPlayerFinished
signal waiting(toggle: bool)

const graceRange = 42
const startSpeed = 1.5

const easySpeedIncrease = 0.75
const easyMoneyIncrease = 1
const mediumSpeedIncrease = 1.5
const mediumMoneyIncrease = 1.5
const hardSpeedIncrease = 2.25
const hardMoneyIncrease = 2

var currentPlayer = 1
var players = 1

var running = true
var left = true
var speed = startSpeed
var move = true
var speedIncrease = 0.75

var score = 0
var successPos = []
var difficultyChosenVar = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Score.scores.append(0)
	players = PlayerInfo.playerCount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	if move and difficultyChosenVar:
		if left:
			position.x += speed
		elif not left:
			position.x += -speed
	if abs(position.x) >= 256:
		if left:
			left = false  
		else:
			left = true
			
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE and not event.is_echo():
			if running and difficultyChosenVar:
				match PlayerInfo.difficulty:
					0:
						speedIncrease = easySpeedIncrease
					1:   
						speedIncrease = mediumSpeedIncrease
					2:
						speedIncrease = hardSpeedIncrease
				
				move = false
				await get_tree().create_timer(0.075).timeout
				move = true
				if move and (position.x >= (successPos[0]-graceRange) && position.x < (successPos[0]+graceRange)) or (position.x >= (successPos[1]-graceRange) && position.x < (successPos[1]+graceRange)) or (position.x >= (successPos[2]-graceRange) && position.x < (successPos[2]+graceRange)):
					#speed stuff
					speed += speedIncrease
					print("Player succedded at position " + str(position.x))
					print("New speed: " +str(speed))
					
					#scoring
					match PlayerInfo.difficulty:
						0:
							score += easyMoneyIncrease*10
							Score.scores[currentPlayer-1] += easyMoneyIncrease
						1:
							score += mediumMoneyIncrease*10
							Score.scores[currentPlayer-1] += mediumMoneyIncrease
						2:
							score += hardMoneyIncrease*10
							Score.scores[currentPlayer-1] += hardMoneyIncrease
					
					#more speed stuff
					speedChange.emit(score)
					move = false
					successPos.clear()
					await get_tree().create_timer(0.5).timeout
					successSig.emit()
					await get_tree().create_timer(0.5).timeout
					move = true
				elif move:
					move = false
					running = false
					print("Player failed at position "  + str(position.x))
					print("Player failed with score " +str(score))
					print("Current player is:" +str(currentPlayer))
					if currentPlayer != players:
						currentPlayer += 1
						print("New player is: " +str(currentPlayer))
					elif currentPlayer == players: 
						if OnlineMultiplayer.isMultiplayer:
							if !multiplayer.is_server():
								rpc("clientSendScore",score)
								if Score.scores[1] == null:
									waiting.emit(true)
									await onlineOtherPlayerFinished
									rpc("clientSendScore",score)
									waiting.emit(false)
							elif multiplayer.is_server():
								rpc("serverSendScore",score)
								if Score.scores[1] == null:
									waiting.emit(true)
									await onlineOtherPlayerFinished
									rpc("serverSendScore",score)
									waiting.emit(false)
						get_tree().change_scene_to_file("res://scenes/finishScreen/finishScreen.tscn")
					failSig.emit()
					
					difficultyChosenVar = false
					successPos.clear()
					
			elif !PlayerInfo.selectingDifficulty:
				resetSig.emit()
				speed = startSpeed
				score = 0
				speedChange.emit(0)
				difficulty.emit()
				await get_tree().create_timer(1).timeout
				move = true
				running = true 

		
			
func successPositionRecieved(_index: int, successPosition: int) -> void:
	successPos.append(successPosition)

func reset() -> void:
	Score.scores.append(0)

func difficultyChosen() -> void:
	if OnlineMultiplayer.isMultiplayer and multiplayer.is_server():
		rpc("setDifficulty", PlayerInfo.difficulty)
	difficultyChosenVar = true

#Online functions

@rpc("authority","call_local","reliable")
func setDifficulty(difficultyNum) -> void:
	difficultyChosenVar = true
	PlayerInfo.selectingDifficulty = false
	PlayerInfo.difficulty = difficultyNum

@rpc("any_peer","call_remote","reliable")
func serverSendScore(sentScore) -> void: #Function is called on the server with data provided by the client
	if !multiplayer.is_server():
		onlineOtherPlayerFinished.emit()
		Score.scores[1] = (sentScore/10)
		print("Recieved " + str(sentScore))
		
@rpc("any_peer","call_remote","reliable") #Function is called on the client with data provided by the server
func clientSendScore(sentScore) -> void:
	if multiplayer.is_server():
		onlineOtherPlayerFinished.emit()
		Score.scores[1] = (sentScore/10)
		print("Recieved " + str(sentScore))
