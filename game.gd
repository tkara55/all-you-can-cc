extends Node2D

@onready var game_over_ui: Node2D = $CanvasLayer/Game_Over_UI
@onready var player: Node2D = $Player
@onready var count_down_label: Label = $CanvasLayer/CountDownLabel
@onready var timer: Timer = $CanvasLayer/CountDownLabel/Timer
@onready var red_button: Sprite2D = $CanvasLayer/RedButton
@onready var green_button: Sprite2D = $CanvasLayer/GreenButton
@onready var camera_2d: Camera2D = $Camera2D
@onready var blue_button_indicator: Sprite2D = $CanvasLayer/BlueButtonIndicator
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bot_holder: Node2D = $BotHolder

var FoodScene: PackedScene = preload("res://scenes/food.tscn")
var BotScene: PackedScene = preload("res://scenes/bot.tscn")

var countdown_value = 3

func _ready() -> void:
	randomize()
	
	# Mavi buton göstergesini kapat
	Global.blue_indicator = $CanvasLayer/BlueButtonIndicator
	Global.blue_indicator.visible = false
	
	# Intro animasyonu
	animation_player.play("start")
	
	# Bot oluştur veya mevcut olanı al
	var bot: Node2D
	if bot_holder.get_child_count() == 0:
		bot = BotScene.instantiate()
		bot_holder.add_child(bot)
	else:
		bot = bot_holder.get_child(0)
	
	if bot:
		Global.bot = bot
		Global.apply_bot_settings()
	
	# Player ve Bot için food oluştur
	add_player_food()
	add_bot_food()
	
	# Pozisyonları ayarla
	setup_positions()
	
	# Game over UI'ı kapalı başlat
	game_over_ui.visible = false
	
	# Geri sayım başlat
	countdown()

# === Pozisyonları düzenleyen kısım ===
func setup_positions():
	var screen_rect = get_viewport().get_visible_rect()
	var cam_pos = camera_2d.global_position
	
	var screen_width = screen_rect.size.x
	var spacing = screen_width * 0.6
	
	var center_x = cam_pos.x
	var y_pos = player.position.y
	
	# Player sol tarafta
	var player_x = center_x - spacing / 2
	player.position = Vector2(player_x, y_pos)
	player.food.position = Vector2(0, 15)  # Player'a göre relative
	blue_button_indicator.position = player.position + Vector2(0, 220)
	
	# Bot sağ tarafta (holder'ı pozisyonla)
	if Global.bot:
		var bot_x = center_x + spacing / 2
		bot_holder.position = Vector2(bot_x, y_pos)
		Global.bot.position = Vector2.ZERO  # Holder içinde merkez
		Global.bot.food.position = Vector2(0, 15)  # Bot'a göre relative
# === Game loop ===
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

# === Food ekleme ===
func add_player_food():
	var player_food = FoodScene.instantiate()
	player.add_child(player_food)
	player.food = player_food

func add_bot_food():
	if Global.bot:
		var bot_food = FoodScene.instantiate()
		Global.bot.add_child(bot_food)
		Global.bot.food = bot_food

# === Geri sayım kısmı ===	
func countdown():
	countdown_value = 3
	count_down_label.text = str(countdown_value)
	timer.start(1.0)
	var shake_tween = create_tween()
	var original_pos = count_down_label.position
	for i in range(1):
		shake_tween.tween_property(count_down_label, "position", original_pos + Vector2(22, 0), 0.03)
		shake_tween.tween_property(count_down_label, "position", original_pos - Vector2(22, 0), 0.03)
		shake_tween.tween_property(count_down_label, "position", original_pos + Vector2(0, 22), 0.03)
		shake_tween.tween_property(count_down_label, "position", original_pos - Vector2(0, 22), 0.03)
	shake_tween.tween_property(count_down_label, "position", original_pos, 0.03)  # geri yerine koy
func _on_timer_timeout() -> void:
	if countdown_value > 1:
		countdown_value -= 1
		count_down_label.text = str(countdown_value)
		var shake_tween = create_tween()
		var original_pos = count_down_label.position
		for i in range(1):
			shake_tween.tween_property(count_down_label, "position", original_pos + Vector2(22, 0), 0.03)
			shake_tween.tween_property(count_down_label, "position", original_pos - Vector2(22, 0), 0.03)
			shake_tween.tween_property(count_down_label, "position", original_pos + Vector2(0, 22), 0.03)
			shake_tween.tween_property(count_down_label, "position", original_pos - Vector2(0, 22), 0.03)
		shake_tween.tween_property(count_down_label, "position", original_pos, 0.03)  # geri yerine koy
	elif countdown_value == 1:
		countdown_value = 0
		count_down_label.text = "Start!"
		
		var shake_tween = create_tween()
		var original_pos = count_down_label.position
		for i in range(10):
			shake_tween.tween_property(count_down_label, "position", original_pos + Vector2(22, 0), 0.03)
			shake_tween.tween_property(count_down_label, "position", original_pos - Vector2(22, 0), 0.03)
			shake_tween.tween_property(count_down_label, "position", original_pos + Vector2(0, 22), 0.03)
			shake_tween.tween_property(count_down_label, "position", original_pos - Vector2(0, 22), 0.03)
		shake_tween.tween_property(count_down_label, "position", original_pos, 0.03)  # geri yerine koy

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
