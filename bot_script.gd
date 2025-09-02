extends Node2D

@export var eat_speed := 0.5
var food: Node = null
var last_key = "right"

func _ready():
	var timer = Timer.new()
	timer.wait_time = eat_speed
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout():
	if food == null:
		return

	food.eat()
	# sırayla left-right yapabilirsin
	if last_key == "right":
		last_key = "left"
	else:
		last_key = "right"
