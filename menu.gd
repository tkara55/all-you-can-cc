extends Node2D
@onready var press_start_label: Label = $PressStartLabel
@onready var timer: Timer = $PressStartLabel/Timer
var timer_detector = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	timer_detector += 1
	if timer_detector % 2 == 0:
		press_start_label.visible = 0
	else:
		press_start_label.visible = 1
