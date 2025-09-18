extends Node2D

var PlayerScene: PackedScene = preload("res://scenes/player.tscn")
var BotScene: PackedScene = preload("res://scenes/bot.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_holder: Node2D = $PlayerHolder
@onready var bot_holder: Node2D = $BotHolder
@onready var intro: Node2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var player_inst = PlayerScene.instantiate()
	var bot_inst = BotScene.instantiate()
	player_holder.add_child(player_inst)
	bot_holder.add_child(bot_inst)
	
	animation_player.play("intro")
	await get_tree().create_timer(2.0).timeout
	animation_player.play_backwards("intro")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
