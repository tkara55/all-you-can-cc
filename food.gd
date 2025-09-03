extends AnimatedSprite2D
var food_health = 60
@onready var food: AnimatedSprite2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func eat(eater : Node):
	if Global.game_running == 1:
		food_health -= 1
		print("%s yedi, kalan health: %d" % [eater.name, food_health])
		if food_health % 10 == 0:
			food.frame += 1
			if food_health <= 0:
				print("%s bitirdi!" % eater.name)
				food.queue_free()
				Global.game_running = 0
