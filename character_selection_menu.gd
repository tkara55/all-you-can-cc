extends Node2D

var BotScene: PackedScene = preload("res://scenes/bot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Global.bots[0].set_bot_name("First")
	Global.bots[0].set_speed(0.1)
	Global.bots[0].set_color(Color.BLACK)
	
	get_tree().change_scene_to_file("res://scenes/game.tscn")
