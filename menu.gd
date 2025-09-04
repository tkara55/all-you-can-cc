extends Node2D
@onready var press_start_label: Label = $PressStartLabel
@onready var timer: Timer = $PressStartLabel/Timer
var timer_detector = 1
@onready var all_you_can_quaff_label: Label = $AllYouCanQuaffLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aycq_label_movement()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_timer_timeout() -> void:
	timer_detector += 1
	if timer_detector % 2 == 0:
		press_start_label.visible = 0
	else:
		press_start_label.visible = 1

func aycq_label_movement():
	var tween = create_tween()
	var original_pos = all_you_can_quaff_label.position

	tween.set_loops() # sonsuz döngü
	tween.tween_property(all_you_can_quaff_label, "position", original_pos + Vector2(0, 10), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(all_you_can_quaff_label, "position", original_pos, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
