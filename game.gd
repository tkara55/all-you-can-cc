extends Node2D


@onready var game_over_ui: Node2D = $CanvasLayer/Game_Over_UI
@onready var player: Node2D = $Player
@onready var count_down_label: Label = $CanvasLayer/CountDownLabel
@onready var timer: Timer = $CanvasLayer/CountDownLabel/Timer
@onready var red_button: Sprite2D = $CanvasLayer/RedButton
@onready var green_button: Sprite2D = $CanvasLayer/GreenButton


var BotScene: PackedScene = preload("res://scenes/bot.tscn")
var FoodScene: PackedScene = preload("res://scenes/food.tscn")

var bot_count: int = 3
var countdown_value = 3

func _ready() -> void:
	randomize()
	Global.blue_indicator = $CanvasLayer/BlueButtonIndicator
	Global.blue_indicator.visible = false
	add_player_food()
	add_bots()
	customize_bots()
	game_over_ui.visible = false
	countdown()
	
func _process(delta: float) -> void:
	if Global.game_state == 2 and not Global.game_over_triggered:
		game_over_ui.visible = true
		print("Game Over triggered!")
		Global.game_over_triggered = true
		return
	
	if Global.game_state == 0:  # countdown
		return
	elif Global.game_state == 1:  # playing
		return
		
func add_player_food():
	var player_food = FoodScene.instantiate()
	add_child(player_food)
	player_food.position = player.position + Vector2(0,50)
	player.food= player_food

func add_bots():
	for i in range(bot_count):
		var bot = BotScene.instantiate()
		add_child(bot)
		bot.position = player.position + Vector2(300 * (i+1),0)
		
		var bot_food = FoodScene.instantiate()
		add_child(bot_food)
		bot_food.position = bot.position + Vector2(0,50)
		
		bot.food = bot_food
		Global.bots.append(bot)

func get_random_color():
	return Color(randf(), randf(), randf())
	
func customize_bots():
	if len(Global.bots) >= 1:
		Global.bots[0].set_speed(0.4)
		Global.bots[0].set_color(get_random_color())
		Global.bots[0].set_bot_name("Kolay_Bot")
	if len(Global.bots) >= 2:
		Global.bots[1].set_speed(0.5)
		Global.bots[1].set_color(get_random_color())
		Global.bots[1].set_bot_name("Normal_Bot")
	if len(Global.bots) >= 3:
		Global.bots[2].set_speed(0.6)
		Global.bots[2].set_color(get_random_color())
		Global.bots[2].set_bot_name("Zor_Bot")


	
func countdown():
	countdown_value = 3
	count_down_label.text = str(countdown_value)
	timer.start(1.0)
	

func _on_timer_timeout() -> void:
	if countdown_value > 1:
		countdown_value -= 1
		count_down_label.text = str(countdown_value)
	elif countdown_value == 1:
		countdown_value = 0
		count_down_label.text = "Basla!"
	else:
		timer.stop()
		count_down_label.visible = false
		Global.game_state = 1
		_run_red_indicator_loop()
		_run_green_indicator_loop()
	
func _run_red_indicator_loop() -> void:
	while Global.game_state == 1:
		var t = create_tween()
		t.tween_property(red_button, "scale", Vector2(2.2, 2.2), 0.05)
		t.tween_property(red_button, "scale", Vector2(2.0, 2.0), 0.05)
		await t.finished
func _run_green_indicator_loop() -> void:
	while Global.game_state == 1:
		var t = create_tween()
		t.tween_property(green_button, "scale", Vector2(2.2, 2.2), 0.05)
		t.tween_property(green_button, "scale", Vector2(2.0, 2.0), 0.05)
		await t.finished
