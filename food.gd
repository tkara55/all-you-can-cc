extends Node2D
class_name Food
var food_health = 0
@onready var sprite: AnimatedSprite2D = $ShakeContainer/AnimatedSprite2D
@onready var shake_container: Node2D = $ShakeContainer
var shake_tween: Tween
var shake_queue: Array = []
var is_shaking = false

# Her yiyecek türünün özellikleri
var food_data = {
	"apple": {
		"max_health": 150,
		"frame_count": 6
	},
	"pear": {
		"max_health": 180,
		"frame_count": 6
	}
}

var food_types = ["apple", "pear"]
var food_types_index = 0
var waiting_for_food = false
var is_falling = false

# Mevcut yiyecek bilgileri
var current_food_name = ""
var max_health = 0
var frame_count = 0
var health_per_frame = 0

func _ready() -> void:
	_setup_food(food_types[0])

func _setup_food(food_name: String):
	current_food_name = food_name
	sprite.animation = food_name
	
	# Yiyecek verilerini al
	max_health = food_data[food_name]["max_health"]
	frame_count = food_data[food_name]["frame_count"]
	health_per_frame = max_health / frame_count
	
	# Canı ve frame'i sıfırla
	food_health = max_health
	sprite.frame = 0
	
	print("Yeni yiyecek: %s, Can: %d, Frame başına can: %d" % [food_name, max_health, health_per_frame])

func eat(eater : Node):
	# Oyun durumu kontrolü - game over durumunda yeme işlemi yapma
	if Global.game_state != 1 or waiting_for_food or is_falling:
		return
		
	food_health -= 1
	print("%s yedi, kalan health: %d" % [eater.name, food_health])
	
	# Her yemede shake efekti
	shake()
	
	# Frame değişimi kontrolü - can azaldıkça frame artsın
	var eaten_health = max_health - food_health
	var target_frame = min(eaten_health / health_per_frame, frame_count - 1)
	
	if sprite.frame != target_frame:
		sprite.frame = target_frame
		
	if food_health <= 0:
		print("%s bitirdi!" % eater.name)
		_handle_food_finished(eater)

func _handle_food_finished(eater: Node):
	food_types_index += 1
	sprite.visible = false
	waiting_for_food = true
	
	if food_types_index >= food_types.size():
		# ÖNCE oyun durumunu değiştir, SONRA queue_free çağır
		Global.game_state = 2
		
		# Bir frame bekle ki diğer objeler durumu görsün
		await get_tree().process_frame
		queue_free()
		return
	
	if eater in Global.bots:
		_start_new_food()
	else:
		pass

func _start_new_food():
	if food_types_index < food_types.size():
		_setup_food(food_types[food_types_index])
		sprite.visible = true
		_food_fall()

func _input(event: InputEvent) -> void:
	if waiting_for_food and Input.is_action_just_pressed("call_food"):
		_start_new_food()

func _food_fall():
	if is_falling:
		return
		
	is_falling = true
	var tween = create_tween()
	var target_pos = position
	
	position = target_pos + Vector2(0, -500)
	
	tween.tween_property(self, "position", target_pos, 1.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	is_falling = false
	waiting_for_food = false

func shake():
	# Shake'i sıraya ekle
	shake_queue.append(true)
	
	# Eğer şu anda shake çalışmıyorsa başlat
	if not is_shaking:
		_process_shake_queue()

func _process_shake_queue():
	# Oyun bitmiş ise shake'leri temizle ve çık
	if Global.game_state != 1:
		shake_queue.clear()
		is_shaking = false
		if shake_tween:
			shake_tween.kill()
		# Pozisyonu sıfırla
		shake_container.position = Vector2.ZERO
		return
		
	if shake_queue.is_empty():
		is_shaking = false
		return
		
	# Sıradan bir shake al
	shake_queue.pop_front()
	is_shaking = true
	
	# Shake animasyonunu çalıştır
	if shake_tween:
		shake_tween.kill()
	
	shake_tween = create_tween()
	var original_pos = Vector2.ZERO
	
	for i in range(3):  # Daha kısa shake (5'ten 3'e)
		shake_tween.tween_property(shake_container, "position", original_pos + Vector2(2, 0), 0.03)
		shake_tween.tween_property(shake_container, "position", original_pos - Vector2(2, 0), 0.03)
		shake_tween.tween_property(shake_container, "position", original_pos + Vector2(0, 2), 0.03)
		shake_tween.tween_property(shake_container, "position", original_pos - Vector2(0, 2), 0.03)
	
	shake_tween.tween_property(shake_container, "position", original_pos, 0.03)
	
	# Animasyon bitince sıradaki shake'i işle
	await shake_tween.finished
	_process_shake_queue()
