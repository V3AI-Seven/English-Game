extends Node2D

var billTexturesArray := [
	#preload("res://moneyTextures/5bill.png"),
	preload("res://moneyTextures/10bill.png")
	#preload("res://moneyTextures/20bill.png"),
	#preload("res://moneyTextures/50bill.png"),
	#preload("res://moneyTextures/100bill.png")
]

func _ready() -> void:
	$moneyTexture.texture = billTexturesArray[randi() % billTexturesArray.size()]
