extends Sprite2D
var last_key = ""
var food: AnimatedSprite2D = null # Oyuncunun önündeki yiyecek


func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	if food == null:
		return
	if Input.is_action_just_pressed("left_eat") and Input.is_action_just_pressed("right_eat"):
		return
	if Input.is_action_just_pressed("left_eat"):
		if last_key == "right":
			food.eat()
		last_key = "left"
		
	if Input.is_action_just_pressed("right_eat"):
		if last_key == "left":
			food.eat()
		last_key = "right"
