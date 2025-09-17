extends Node

# 0: countdown, 1: playing, 2: game_over
var game_state = 0
var game_over_triggered: bool = false
var bot: Node = null  # Tek bot
var blue_indicator: Node = null

# Bot tiplerini tanımla
var bot_types = {
	"easy": {
		"name": "Easy Bot",
		"speed": 0.5,
		"color": Color.LIGHT_GREEN,
		"mask_visible": false
	},
	"medium": {
		"name": "Medium Bot", 
		"speed": 0.3,
		"color": Color.INDIGO,
		"mask_visible": false
	},
	"hard": {
		"name": "Hard Bot",
		"speed": 0.1,
		"color": Color.BLACK,
		"mask_visible": true
	}
}

var selected_bot_type = "easy"  # Varsayılan bot tipi

func set_bot_type(bot_type: String):
	if bot_types.has(bot_type):
		selected_bot_type = bot_type

func apply_bot_settings():
	if bot != null and bot_types.has(selected_bot_type):
		var bot_data = bot_types[selected_bot_type]
		bot.set_bot_name(bot_data["name"])
		bot.set_speed(bot_data["speed"])
		bot.set_color(bot_data["color"])
		bot.set_mask_visible(bot_data["mask_visible"])
