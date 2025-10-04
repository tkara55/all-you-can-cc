extends Node2D

var bot_name = "Bot"
var eat_speed = 1.0
var food: Node = null
var eat_timer = 0.0
var is_bot = true

@onready var idle: Sprite2D = $Sprites/Idle
@onready var mask: Sprite2D = $Sprites/Mask
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var ProjectileScene = preload("res://scenes/projectile.tscn")
var throw_cooldown = 5.0
var throw_timer = 0.0
var can_throw = true

func _ready() -> void:
	Global.bot_ref = animation_player

func _process(delta: float) -> void:
	if food == null or not is_instance_valid(food):
		return
	
	eat_timer += delta
	if eat_timer >= eat_speed:
		eat_timer = 0.0
		if food.has_method("eat"):
			food.eat(self)
# Fırlatma
	if not can_throw:
		throw_timer += delta
		if throw_timer >= throw_cooldown:
			can_throw = true
			throw_timer = 0.0
	elif Global.game_state == 1 and randf() < 0.2 * delta:
		throw_object()
		
func throw_object():
	if Global.game_state == 2:  # Sadece oyun oynanırken fırlat
		return
		
	can_throw = false
	throw_timer = 0.0
	
	var projectile = ProjectileScene.instantiate()
	get_parent().get_parent().add_child(projectile)
	projectile.global_position = global_position + Vector2(-30, 0)
	projectile.direction = Vector2.LEFT
	
func set_speed(speed: float):
	eat_speed = speed

func set_bot_name(name_str: String):
	bot_name = name_str
	name = name_str

func set_color(color: Color):
	idle.modulate = color
	
func set_mask_visible(visible: bool):
	mask.visible = visible
