extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Global.set_bot_type("easy")
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_button_2_pressed() -> void:
	Global.set_bot_type("medium")
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_button_3_pressed() -> void:
	Global.set_bot_type("hard")
	get_tree().change_scene_to_file("res://scenes/game.tscn")
