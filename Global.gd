extends Node

# 0: countdown, 1: playing, 2: game_over
var game_state = 0
var game_over_triggered: bool = false
var bot: Node = null  # Tek bot
var blue_indicator: Node = null
var player_ref : Node = null
var bot_ref : Node = null
var projectile_speed = 0
var projectile_texture : Texture2D = null

# Bot tiplerini tanımla
var bot_types = {
	"easy": {
		"name": "Easy Bot",
		"speed": 0.5,
		"color": Color.LIGHT_GREEN,
		"mask_visible": false,
		"ability_to_throw": false,  # Easy bot fırlatamaz
		"throw_cooldown": 0.0,
		"throw_chance": 0.0,
		"projectile_speed":0.0
	},
	"medium": {
		"name": "Medium Bot", 
		"speed": 0.3,
		"color": Color.INDIGO,
		"mask_visible": false,
		"ability_to_throw": true,  # Medium bot fırlatabilir
		"throw_cooldown": 3, 
		"throw_chance": 1,
		"projectile_speed":500 
	},
	"hard": {
		"name": "Hard Bot",
		"speed": 0.1,
		"color": Color.BLACK,
		"mask_visible": true,
		"ability_to_throw": true,  # Hard bot fırlatabilir
		"throw_cooldown": 1.5,  # 1.5 saniyede bir fırlatabilir
		"throw_chance": 1.2,  # Saniyede %120 şans (çok agresif)
		"projectile_speed":1000
	},
	"insane": {
		"name": "Insane Bot",
		"speed": 0.1,
		"color": Color.ORANGE,
		"mask_visible": false,
		"ability_to_throw": true,  # Hard bot fırlatabilir
		"throw_cooldown": 1.5,  # 1.5 saniyede bir fırlatabilir
		"throw_chance": 1.2,  # Saniyede %120 şans (çok agresif)
		"projectile_speed":1000
	}
}

var selected_bot_type = "medium"  # Varsayılan bot tipi

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
		bot.set_throw_ability(bot_data["ability_to_throw"])
		bot.set_throw_cooldown(bot_data["throw_cooldown"])
		bot.set_throw_chance(bot_data["throw_chance"])
		bot.set_projectile_speed(bot_data["projectile_speed"])
