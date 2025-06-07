extends Node2D

signal speedChange(speed: float)
signal successSig
signal failSig
signal resetSig

var left = true
var speed = 1
var successPos = []
var move = true
var running = true
const graceRange = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
			if (position.x >= (successPos[0]-graceRange) && position.x < (successPos[0]+graceRange)) or (position.x >= (successPos[1]-graceRange) && position.x < (successPos[1]+graceRange)) or (position.x >= (successPos[2]-graceRange) && position.x < (successPos[2]+graceRange)):
				speed += 0.75
				print("Player succedded at position " + str(position.x)) 

				speedChange.emit(speed)
				move = false
				successPos.clear()
				await get_tree().create_timer(1).timeout
				successSig.emit()
				move = true
			else:
				print("Player failed at position "  + str(position.x))
				speedChange.emit(1)
				failSig.emit()
				move = false
				running = false
		else:
			resetSig.emit()
			await get_tree().create_timer(1).timeout
			running = true 
			move = true
			successPos.clear()


		
			
func successPositionRecieved(_index: int, successPosition: int) -> void:
	successPos.append(successPosition)
