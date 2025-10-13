extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
var direction = Vector2.LEFT

var projectile_textures = [
	preload("res://assets/fork.png"),
	preload("res://assets/kitchen_kinfe.png"),
]

func _ready() -> void:
	# Eğer globalde texture seçilmediyse, bir kere seç
	if Global.projectile_texture == null:
		projectile_textures.shuffle()
		Global.projectile_texture = projectile_textures[0]
	
	# Seçilen global texture'u kullan
	sprite.texture = Global.projectile_texture

func _process(delta: float) -> void:
	position += direction * delta * Global.projectile_speed
	rotation += 6 * delta
