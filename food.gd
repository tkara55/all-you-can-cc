extends AnimatedSprite2D
var food_health = 60
@onready var food: AnimatedSprite2D = $"."
var food_types = ["apple" , "pear"]
var food_types_index = 0
var waiting_for_food = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation = food_types[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func eat(eater : Node):
	if Global.game_running == 1 and not waiting_for_food:
		food_health -= 1
		print("%s yedi, kalan health: %d" % [eater.name, food_health])
		
		if food_health % 10 == 0:
			food.frame += 1
			#shake()
			
			if food_health <= 0:
				print("%s bitirdi!" % eater.name)
				food_types_index += 1
				food.visible = false
				
				if food_types_index >= food_types.size(): 
					food.queue_free()
					Global.game_running = 0
					return
				
				# Eğer bot bitirdiyse direkt düşsün
				if eater in Global.bots:
					animation = food_types[food_types_index]
					food_health = 60
					food.frame = 0
					food.visible = true
					waiting_for_food = true  # düşüş boyunca yemeyi engelle
					await food_fall()     # düşüş bitene kadar bekle
					waiting_for_food = false  # düşüş bitti, bot yeni yemeğe başlayabilir
				else: # Player bitirdiyse tuşa basmayı bekle
					#player
					waiting_for_food = true
func shake():
	var tween = create_tween()
	var original_pos = position

	for i in range(5): # 3 kere salla # İÇİ ÖNEMLİ
		tween.tween_property(self, "position", original_pos + Vector2(4, 0), 0.05)
		tween.tween_property(self, "position", original_pos - Vector2(4, 0), 0.05)
		tween.tween_property(self, "position", original_pos + Vector2(0, 4), 0.05)
		tween.tween_property(self, "position", original_pos - Vector2(0, 4), 0.05)

	tween.tween_property(self, "position", original_pos, 0.05)

func _input(event: InputEvent) -> void:
	if waiting_for_food == true and Input.is_action_just_pressed("call_food"):
		
		if food_types_index < food_types.size():
			animation = food_types[food_types_index]
			food_health = 60
			food.frame = 0
			food.visible = true
			food_fall()
		
func food_fall():
	var tween = create_tween()
	var target_pos = position
	
	position = target_pos + Vector2(0,-500)
	
	tween.tween_property(self, "position", target_pos, 1.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	waiting_for_food = false
	
	
