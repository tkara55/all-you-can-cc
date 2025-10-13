extends Node2D

@onready var bot1: Node2D = $Bot1
@onready var bot2: Node2D = $Bot2
@onready var bot3: Node2D = $Bot3
@onready var bot4: Node2D = $Bot4
@onready var bot5: Node2D = $Bot5

var current_index = 0
var bots = []

var start_x = 0
var spacing = 400

# Yeni: Tween kilidi
var is_sliding = false


func _ready() -> void:
	# Bot verilerini uygula
	apply_bot_settings(bot1, "easy")
	apply_bot_settings(bot2, "medium")
	apply_bot_settings(bot3, "hard")
	apply_bot_settings(bot4, "insane")
	apply_bot_settings(bot5, "medium")

	bots = [bot1, bot2, bot3, bot4, bot5]
	bots[current_index].scale = Vector2(7.5,7.5)

	# Başlangıç pozisyonlarını hizala
	for i in range(len(bots)):
		bots[i].position = Vector2(start_x + (i - current_index) * spacing, 0)
	
	update_highlight()


func _on_button_right_pressed() -> void:
	if is_sliding:
		return
	if current_index == len(bots) - 1:
		return
	current_index += 1
	slide_bots()


func _on_button_left_pressed() -> void:
	if is_sliding:
		return
	if current_index == 0:
		return
	current_index -= 1
	slide_bots()


func slide_bots():
	is_sliding = true
	var tween = create_tween().set_parallel(true)
	
	for i in range(len(bots)):
		var target_x = (i - current_index) * spacing
		tween.tween_property(bots[i], "position:x", target_x, 0.750)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
	
	tween.tween_callback(func ():
		is_sliding = false
		update_highlight()
	)


func update_highlight():
	for i in range(len(bots)):
		var tween = create_tween()
		if i == current_index:
			tween.tween_property(bots[i], "scale", Vector2(7.5, 7.5), 0.3)
			bots[i].modulate = Color(1, 1, 1, 1)
		else:
			tween.tween_property(bots[i], "scale", Vector2(6, 6), 0.3)
			bots[i].modulate = Color(1, 1, 1, 0.4)


func _on_start_button_pressed() -> void:
	print(bots[current_index])
	
func apply_bot_settings(bot_node: Node2D, bot_type: String):
	if bot_node == null or not Global.bot_types.has(bot_type):
		return
	
	var bot_data = Global.bot_types[bot_type]
	var idle_sprite = bot_node.get_node_or_null("Sprites/Idle")
	var mask_sprite = bot_node.get_node_or_null("Sprites/Mask")
	var anim_player = bot_node.get_node_or_null("AnimationPlayer")
	
	if idle_sprite:
		idle_sprite.modulate = bot_data["color"]
	
	if mask_sprite:
		mask_sprite.visible = bot_data["mask_visible"]
	
	if anim_player:
		anim_player.stop()
