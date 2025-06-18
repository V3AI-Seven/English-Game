extends Node2D
var successZonesPos = []
var successZoneClones = []
const successZones = 3
const maxSeperationDist = 60
signal successPositionSig(index:int, position:int)

func reset():
	successZonesPos.clear()
	successZoneClones.clear()
	randomize()
	$success.visible = false
	var successPosition
	for i in range(successZones):
		var possibleSuccessPosition = 0
		match i:
			0:
				successPosition = randi_range(-256,256)
				successZonesPos.append(successPosition)
			1:
				possibleSuccessPosition = randi_range(-256,256)
				while (possibleSuccessPosition >= (successZonesPos[0]-maxSeperationDist) && possibleSuccessPosition < (successZonesPos[0]+maxSeperationDist)):
					possibleSuccessPosition = randi_range(-256,256)
				successPosition = possibleSuccessPosition
				successZonesPos.append(successPosition)
			2:
				possibleSuccessPosition = randi_range(-256,256)
				while (possibleSuccessPosition >= (successZonesPos[0]-maxSeperationDist) && possibleSuccessPosition < (successZonesPos[0]+maxSeperationDist)) or (possibleSuccessPosition >= (successZonesPos[1]-maxSeperationDist) && possibleSuccessPosition < (successZonesPos[1]+maxSeperationDist)):
					possibleSuccessPosition = randi_range(-256,256)
				successPosition = possibleSuccessPosition
				successZonesPos.append(successPosition)
				
		print("Centre of success " + str(i+1) + " at " + str(successPosition))
		successPositionSig.emit(i,successPosition)
		
		var successClone = $success.duplicate()
		add_child(successClone)
		successZoneClones.append(successClone)
		
		successClone.position = Vector2(successPosition,0)
		successClone.visible = true
		
		


func _ready() -> void:
	reset()


func successReset() -> void:
	for child in successZoneClones:
		child.queue_free()
	reset()


func failReset() -> void:
	for child in successZoneClones:
		child.queue_free()
	reset()
