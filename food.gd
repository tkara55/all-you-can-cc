extends AnimatedSprite2D
var food_health = 60
@onready var food: AnimatedSprite2D = $"."
var food_types = ["apple" , "pear"]
var food_types_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = food_types[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func eat(eater : Node):
	if Global.game_running == 1:
		food_health -= 1
		print("%s yedi, kalan health: %d" % [eater.name, food_health])
		if food_health % 10 == 0:
			food.frame += 1
			shake()
			if food_health <= 0:
				print("%s bitirdi!" % eater.name)
				food_types_index += 1
				
				if food_types_index < food_types.size():
					animation = food_types[food_types_index]
					food_health = 60
					food.frame = 0
					
				else :
					food.queue_free()
					Global.game_running = 0
func shake():
	var tween = create_tween()
	var original_pos = position

	for i in range(5): # 3 kere salla # İÇİ ÖNEMLİ
		tween.tween_property(self, "position", original_pos + Vector2(4, 0), 0.05)
		tween.tween_property(self, "position", original_pos - Vector2(4, 0), 0.05)
		tween.tween_property(self, "position", original_pos + Vector2(0, 4), 0.05)
		tween.tween_property(self, "position", original_pos - Vector2(0, 4), 0.05)

	tween.tween_property(self, "position", original_pos, 0.05)
