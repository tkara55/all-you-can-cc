extends Node2D
@onready var bot: Node2D = $Bot
@onready var bot_2: Node2D = $Bot2
@onready var bot_3: Node2D = $Bot3
@onready var bot_4: Node2D = $Bot4

func _ready() -> void:
	Global.set_bot_type("easy")
	var bots = [bot,bot_2,bot_3]
	for b in bots:
		var anim_player = b.get_node_or_null("AnimationPlayer")
		anim_player.stop()
