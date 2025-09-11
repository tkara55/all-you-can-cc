extends Node2D
var food: Food = null # Oyuncunun önündeki yiyecek
var last_key = ""


func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	if food == null:
		return
	if Input.is_action_just_pressed("left_eat") and Input.is_action_just_pressed("right_eat"):
		return
	if Input.is_action_just_pressed("left_eat"):
		if last_key == "right":
			food.eat(self)
		last_key = "left"
		
	if Input.is_action_just_pressed("right_eat"):
		if last_key == "left":
			food.eat(self)
		last_key = "right"
