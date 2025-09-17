extends Node

# 0: countdown, 1: playing, 2: game_over
var game_state = 0
var game_over_triggered: bool = false
var bots: Array = []
var blue_indicator: Node = null
var bot_names: Array = ["First","Second","Third"]
