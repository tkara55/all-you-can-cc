extends AnimatedSprite2D
var food_health = 60
@onready var food: AnimatedSprite2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	
func eat():
	food_health -= 1
	print(food_health)
	if food_health % 10 == 0:
		food.frame += 1
		if food_health <= 0:
			food.queue.free()
		
