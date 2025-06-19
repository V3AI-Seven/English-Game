extends Node2D

signal speedChange(speed: int)
signal successSig
signal failSig
signal resetSig
signal difficulty

const graceRange = 42
const speedIncrease = 0.75
const startSpeed = 1.5

var players = 1
var score = 0
var currentPlayer = 1
var left = true
var speed = startSpeed
var successPos = []
var move = true
var running = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Score.scores.append(0)
	players = PlayerInfo.playerCount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if move:
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
			if running:
				#await get_tree().create_timer(0.05).timeout
				if move and (position.x >= (successPos[0]-graceRange) && position.x < (successPos[0]+graceRange)) or (position.x >= (successPos[1]-graceRange) && position.x < (successPos[1]+graceRange)) or (position.x >= (successPos[2]-graceRange) && position.x < (successPos[2]+graceRange)):
					speed += speedIncrease
					print("Player succedded at position " + str(position.x))
					score += 10
					Score.scores[currentPlayer-1] += 1
					

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
						get_tree().change_scene_to_file("res://scenes/finishScreen/finishScreen.tscn")
					failSig.emit()
					successPos.clear()
					
			else:
				resetSig.emit()
				speed = startSpeed
				score = 0
				speedChange.emit(0)
				
				await get_tree().create_timer(1).timeout
				move = true
				running = true 

		
			
func successPositionRecieved(_index: int, successPosition: int) -> void:
	successPos.append(successPosition)

func reset() -> void:
	Score.scores.append(0)
