extends Node2D

@onready var game_over_ui: Node2D = $CanvasLayer/Game_Over_UI
@onready var player: Node2D = $Player
@onready var count_down_label: Label = $CanvasLayer/CountDownLabel
@onready var timer: Timer = $CanvasLayer/CountDownLabel/Timer
@onready var red_button: Sprite2D = $CanvasLayer/RedButton
@onready var green_button: Sprite2D = $CanvasLayer/GreenButton
@onready var camera_2d: Camera2D = $Camera2D
@onready var blue_button_indicator: Sprite2D = $CanvasLayer/BlueButtonIndicator

var BotScene: PackedScene = preload("res://scenes/bot.tscn")
var FoodScene: PackedScene = preload("res://scenes/food.tscn")

var countdown_value = 3

func _ready() -> void:
	randomize()
	Global.blue_indicator = $CanvasLayer/BlueButtonIndicator
	Global.blue_indicator.visible = false
	
	add_player_food()
	add_bot()
	Global.apply_bot_settings()  # Seçilen bot ayarlarını uygula
	setup_positions() # oyuncu + bot pozisyonlarını ayarla
	game_over_ui.visible = false
	countdown()

# === Pozisyonları düzenleyen kısım ===
func setup_positions():
	var screen_rect = get_viewport().get_visible_rect()
	var cam_pos = camera_2d.global_position
	
	# İki karakter için pozisyonlar (player ve bot)
	var screen_width = screen_rect.size.x
	var spacing = screen_width * 0.6  # Karakterler arası mesafe
	
	var center_x = cam_pos.x
	var y_pos = player.position.y
	
	# Player sol tarafta
	var player_x = center_x - spacing / 2
	player.position = Vector2(player_x, y_pos)
	player.food.position = player.position + Vector2(0, 50)
	blue_button_indicator.position = player.position + Vector2(0, 180)
	
	# Bot sağ tarafta
	var bot_x = center_x + spacing / 2
	Global.bot.position = Vector2(bot_x, y_pos)
	Global.bot.food.position = Global.bot.position + Vector2(0, 50)

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
	player.food = player_food

func add_bot():
	var bot = BotScene.instantiate()
	add_child(bot)
	
	var bot_food = FoodScene.instantiate()
	add_child(bot_food)
	
	bot.food = bot_food
	Global.bot = bot  # Tek bot olarak ata

# === Geri sayım kısmı ===	
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
	
# === Göstergeler ===
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
