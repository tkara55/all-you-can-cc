extends Node2D

var player_scene: PackedScene = preload("res://Player.tscn")
var bot_scene: PackedScene = preload("res://Bot.tscn")
var food_scene: PackedScene = preload("res://Food.tscn")

# Bot sayısı
@export var bot_count: int = 4

# Oyuncuların yatayda sıralanması için offset
@export var spacing: Vector2 = Vector2(200, 0)

func _ready():
	# Player spawn et
	var player = player_scene.instantiate()
	add_child(player)
	player.position = Vector2(200, 400) # sahnede istediğin yere konumlandır

	# Player’ın food’u
	var player_food = food_scene.instantiate()
	add_child(player_food)
	player_food.position = player.position + Vector2(0, -100)
	player.food = player_food

	# Bot spawn et
	for i in range(bot_count):
		var bot = bot_scene.instantiate()
		add_child(bot)
		bot.position = Vector2(200 + (i+1) * spacing.x, 400) # yan yana diziliyor

		var bot_food = food_scene.instantiate()
		add_child(bot_food)
		bot_food.position = bot.position + Vector2(0, -100)
		bot.food = bot_food
	
