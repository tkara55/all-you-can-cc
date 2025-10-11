extends Node2D
var food: Food = null # Oyuncunun önündeki yiyecek
var last_key = ""
var is_ducking = false
var is_stunned = false
@onready var animation_player: AnimationPlayer = $DodgeZone/AnimationPlayer



func _ready() -> void:
	Global.player_ref = animation_player

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("duck") and not is_ducking and not is_stunned and Global.game_state == 1:
		duck()
	if is_stunned or is_ducking or food == null:
		return
	if Input.is_action_just_pressed("left_eat") and Input.is_action_just_pressed("right_eat"):
		return
	if Input.is_action_just_pressed("left_eat"):
		if last_key == "right":
			food.eat(self)
		last_key = "left"
		
	if Input.is_action_just_pressed("right_eat"):
		if last_key == "left":
			food.eat(self)
		last_key = "right"
func duck():
	if is_ducking or is_stunned:
		return
	is_ducking = true
	animation_player.play("duck")
	print("ducked")
	await animation_player.animation_finished
	animation_player.play("idle")
	is_ducking = false
	
func _on_dodge_zone_area_entered(area: Area2D) -> void:
	if not is_ducking:
		hit_by_projectile()
		
func hit_by_projectile():
	if is_stunned:
		return
	print("stunned")
	stun(2.0)
	
func stun(duration: float):
	is_stunned = true
	last_key = ""
	await get_tree().create_timer(duration).timeout
	is_stunned = false
