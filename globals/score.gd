extends Node
var scores = []
var highScore = 0

#reading high score
func _ready() -> void:
	var file = FileAccess.open("user://score.dat", FileAccess.READ)
	if FileAccess.file_exists("user://score.dat"):
		var savedHigh = file.get_var()
		if savedHigh != null:
			highScore = savedHigh
			print("Read " + str(savedHigh) + " from stored high score" )
		else:
			printerr("Corrupted save file detected, deleting")
			DirAccess.remove_absolute("user://score.dat")
