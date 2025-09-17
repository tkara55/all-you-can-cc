extends Node2D

var bot_name = "Bot"
var eat_speed = 1.0
var food: Node = null
var eat_timer = 0.0
var is_bot = true
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var mask: Sprite2D = $Mask

func _process(delta: float) -> void:
	if food == null or not is_instance_valid(food):
		return
	
	eat_timer += delta
	if eat_timer >= eat_speed:
		eat_timer = 0.0
		if food.has_method("eat"):
			food.eat(self)

func set_speed(speed: float):
	eat_speed = speed

func set_bot_name(name_str: String):
	bot_name = name_str
	name = name_str

func set_color(color: Color):
	animated_sprite_2d.modulate = color
	
func set_mask_visible(visible: bool):
	mask.visible = visible
