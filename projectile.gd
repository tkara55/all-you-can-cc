extends Area2D

var speed = 1000	
var direction = Vector2.LEFT
var projectile_textures = ["asd","asdf","asdfgh"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	projectile_textures.shuffle()
	print(projectile_textures[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * delta * speed
	rotation += 5 * delta
