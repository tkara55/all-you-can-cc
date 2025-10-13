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

# Fırlatma özellikleri
var ability_to_throw = false  # Bot fırlatabilir mi?
var throw_cooldown = 2.0  # Fırlatmalar arası bekleme süresi
var throw_chance = 0.9  # Saniye başına fırlatma şansı
var throw_timer = 0.0
var can_throw = true

func _ready() -> void:
	Global.bot_ref = animation_player

func _process(delta: float) -> void:
	if food == null or not is_instance_valid(food):
		return
	
	# Yeme işlemi
	eat_timer += delta
	if eat_timer >= eat_speed:
		eat_timer = 0.0
		if food.has_method("eat"):
			food.eat(self)
	
	# Fırlatma işlemi - sadece yetenekliyse
	if ability_to_throw:
		if not can_throw:
			throw_timer += delta
			if throw_timer >= throw_cooldown:
				can_throw = true
				throw_timer = 0.0
		elif Global.game_state == 1 and randf() < throw_chance * delta:
			throw_object()
		
func throw_object():
	if Global.game_state != 1 or not ability_to_throw:
		return
		
	can_throw = false
	throw_timer = 0.0
	
	var projectile = ProjectileScene.instantiate()
	get_parent().get_parent().add_child(projectile)
	projectile.global_position = global_position + Vector2(-30, -150)
	projectile.direction = Vector2.LEFT

# === Bot ayarları ===
func set_speed(speed: float):
	eat_speed = speed
	
func set_bot_name(name_str: String):
	bot_name = name_str
	name = name_str
	
func set_color(color: Color):
	idle.modulate = color
	
func set_mask_visible(visible: bool):
	mask.visible = visible

func set_throw_ability(can_throw_projectiles: bool):
	ability_to_throw = can_throw_projectiles
	
func set_throw_cooldown(cooldown: float):
	throw_cooldown = cooldown
	
func set_throw_chance(chance: float):
	throw_chance = chance
	
func set_projectile_speed(speed: float):
	Global.projectile_speed = speed
	
func stop():
	# Oyun bittiğinde botun durması için
	set_process(false)
