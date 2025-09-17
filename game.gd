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

var bot_count: int = 1
var countdown_value = 3

func _ready() -> void:
	randomize()
	Global.blue_indicator = $CanvasLayer/BlueButtonIndicator
	Global.blue_indicator.visible = false
	
	add_player_food()
	add_bots()
	Global.customize_bots()
	setup_positions() # oyuncu + botları ekrana eşit aralıkla yerleştir
	game_over_ui.visible = false
	countdown()

# === Pozisyonları düzenleyen kısım ===
func setup_positions():
	var screen_rect = get_viewport().get_visible_rect()
	var cam_pos = camera_2d.global_position
	
	# Spacing'i azaltmak için ekranın sadece ortasındaki kısmını kullan
	var screen_width = screen_rect.size.x
	var usable_width = screen_width * 0.75  # Ekranın %70'ini kullan (daha yakın)
	
	# Merkezi alan hesapla
	var center_x = cam_pos.x
	var left = center_x - usable_width / 2
	var right = center_x + usable_width / 2
	
	var total_slots = bot_count + 1 # player + bots
	var y_pos = player.position.y
	
	for i in range(total_slots):
		# Soldan sağa eşit aralıkla dağıt ama daha yakın
		var x_pos = lerp(left, right, float(i) / (total_slots - 1))
		
		if i == 0:
			# Player
			player.position = Vector2(x_pos, y_pos)
			player.food.position = player.position + Vector2(0, 50)
			blue_button_indicator.position = player.position + Vector2(0, 180)
		else:
			# Botlar
			var bot = Global.bots[i - 1]
			bot.position = Vector2(x_pos, y_pos)
			bot.food.position = bot.position + Vector2(0, 50)

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

func add_bots():
	for i in range(bot_count):
		var bot = BotScene.instantiate()
		add_child(bot)
		
		var bot_food = FoodScene.instantiate()
		add_child(bot_food)
		
		bot.food = bot_food
		Global.bots.append(bot)

func get_random_color():
	return Color(randf(), randf(), randf())
	

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
