extends Node2D

signal speedChange(speed: float)
signal successSig
signal failSig
signal resetSig

var players = 1
var score = 0
var currentPlayer = 1
var left = true
var speed = 1
var successPos = []
var move = true
var running = true
const graceRange = 30


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Score.scores.append(0)
	players = Players.playerCount

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
			
func _input(_ev):
	if Input.is_key_pressed(KEY_SPACE):    
		if running == true:
			await get_tree().create_timer(0.01).timeout
			if (position.x >= (successPos[0]-graceRange) && position.x < (successPos[0]+graceRange)) or (position.x >= (successPos[1]-graceRange) && position.x < (successPos[1]+graceRange)) or (position.x >= (successPos[2]-graceRange) && position.x < (successPos[2]+graceRange)):
				speed += 0.75
				print("Player succedded at position " + str(position.x))
				score += 1
				Score.scores[currentPlayer-1] += 1
				

				speedChange.emit(score)
				move = false
				successPos.clear()
				await get_tree().create_timer(0.5).timeout
				successSig.emit()
				await get_tree().create_timer(0.5).timeout
				move = true
			else:
				print("Player failed at position "  + str(position.x))
				print("Player failed with score " +str(score))
				print("Current player is:" +str(currentPlayer))
				if currentPlayer != players:
					currentPlayer += 1
					print("New player is: " +str(currentPlayer))
				elif currentPlayer == players: 
					get_tree().change_scene_to_file("res://finishScreen.tscn")
				failSig.emit()
				successPos.clear()
				
				move = false
				running = false
		else:
			resetSig.emit()
			speed = 1
			score = 0
			speedChange.emit(0)
			
			await get_tree().create_timer(1).timeout
			running = true 
			move = true

		
			
func successPositionRecieved(_index: int, successPosition: int) -> void:
	successPos.append(successPosition)



func reset() -> void:
	Score.scores.append(0)
