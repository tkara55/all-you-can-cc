extends Node2D
class_name Food
var food_health = 60
@onready var sprite: AnimatedSprite2D = $ShakeContainer/AnimatedSprite2D
@onready var shake_container: Node2D = $ShakeContainer

var shake_tween: Tween
var food_types = ["apple", "pear"]
var food_types_index = 0
var waiting_for_food = false
var is_falling = false  # düşüş sırasında çoklu çağrıları engeller

func _ready() -> void:
	sprite.animation = food_types[0]

func eat(eater : Node):
	if Global.game_running == 0 or waiting_for_food or is_falling:
		return
		
	food_health -= 1
	print("%s yedi, kalan health: %d" % [eater.name, food_health])
	
	if food_health % 10 == 0:
		sprite.frame += 1
		shake()
		
		if food_health <= 0:
			print("%s bitirdi!" % eater.name)
			_handle_food_finished(eater)

func _handle_food_finished(eater: Node):
	food_types_index += 1
	sprite.visible = false
	waiting_for_food = true
	
	if food_types_index >= food_types.size():
		queue_free()
		Global.game_running = 0
		
		
		#OYUNUN BİTİMİ
		
		return
	
	if eater in Global.bots:
		_start_new_food()
	else:
		pass

func _start_new_food():
	if food_types_index < food_types.size():
		sprite.animation = food_types[food_types_index]
		food_health = 60
		sprite.frame = 0
		sprite.visible = true
		_food_fall()

func _input(event: InputEvent) -> void:
	if waiting_for_food and Input.is_action_just_pressed("call_food"):
		_start_new_food()

func _food_fall():
	if is_falling:
		return
		
	is_falling = true
	var tween = create_tween()
	var target_pos = position
	
	position = target_pos + Vector2(0, -500)
	
	tween.tween_property(self, "position", target_pos, 1.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	is_falling = false
	waiting_for_food = false

func shake():
	if shake_tween:
		shake_tween.kill()
	
	shake_tween = create_tween()
	var original_pos = Vector2.ZERO
	
	for i in range(5):
		shake_tween.tween_property(shake_container, "position", original_pos + Vector2(2, 0), 0.05)
		shake_tween.tween_property(shake_container, "position", original_pos - Vector2(2, 0), 0.05)
		shake_tween.tween_property(shake_container, "position", original_pos + Vector2(0, 2), 0.05)
		shake_tween.tween_property(shake_container, "position", original_pos - Vector2(0, 2), 0.05)
	
	shake_tween.tween_property(shake_container, "position", original_pos, 0.05)
	
