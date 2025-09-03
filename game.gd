extends Node2D

@onready var player: AnimatedSprite2D = $Player
var BotScene: PackedScene = preload("res://scenes/bot.tscn")
var FoodScene: PackedScene = preload("res://scenes/food.tscn")

var bot_count: int = 3
var bots: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	add_player_food()
	add_bots()
	customize_bots()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
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
		
		bots.append(bot)

func get_random_color():
	return Color(randf(), randf(), randf())
	

func customize_bots():
	if len(bots) >= 1:
		bots[0].set_speed(100)
		bots[0].set_color(get_random_color())
		bots[0].set_bot_name("Kolay_Bot")
	if len(bots) >= 2:
		bots[1].set_speed(100)
		bots[1].set_color(get_random_color())
		bots[1].set_bot_name("Normal_Bot")
	if len(bots) >= 3:
		bots[2].set_speed(0.05)
		bots[2].set_color(get_random_color())
		bots[2].set_bot_name("Zor_Bot")
		
	
