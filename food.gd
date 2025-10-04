extends Node2D
class_name Food

@onready var sprite: AnimatedSprite2D = $ShakeContainer/AnimatedSprite2D
@onready var shake_container: Node2D = $ShakeContainer
@onready var shake_reset_timer: Timer = Timer.new()
var blue_indicator_active = false
var shake_tween: Tween
var shake_queue: Array = []
var is_shaking = false
var food_health = 0
# Her yiyecek türünün özellikleri
var food_data = {
	"apple": {
		"max_health": 6,
		"frame_count": 6
	},
	"pear": {
		"max_health": 60,
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
	shake_reset_timer.one_shot = true
	shake_reset_timer.wait_time = 0.25  # yarım saniye içinde basmazsa shake durur
	shake_reset_timer.timeout.connect(_on_shake_timeout)
	add_child(shake_reset_timer)
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
	if Global.game_state != 1 or waiting_for_food or is_falling:
		return
		
	food_health -= 1
	print("%s yedi, kalan health: %d" % [eater.name, food_health])
	
	shake()
	shake_reset_timer.start() # her yemede timer resetlenir
	
	var eaten_health = max_health - food_health
	var target_frame = min(eaten_health / health_per_frame, frame_count - 1)
	if sprite.frame != target_frame:
		sprite.frame = target_frame
		
	if food_health <= 0:
		_handle_food_finished(eater)

func _handle_food_finished(eater: Node):
	food_types_index += 1
	sprite.visible = false
	waiting_for_food = true
	
	if food_types_index >= food_types.size(): #OYUN BİTİMİİİİİ
		# ÖNCE oyun durumunu değiştir, SONRA queue_free çağır 
		Global.game_state = 2
		
		Global.bot_ref.stop()
		Global.player_ref.stop()
		
		# Bir frame bekle ki diğer objeler durumu görsün
		await get_tree().process_frame
		queue_free()
		return
	
	if eater.name == "Player":
		Global.blue_indicator.visible = true
		blue_indicator_active = true
		blue_indicator_animation()
	elif eater == Global.bot:  # Bot kontrolü güncellendi
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
	shake_queue.clear()
	is_shaking = false
	is_falling = true
	var tween = create_tween()
	var target_pos = position
	
	if blue_indicator_active:
		blue_indicator_active = false
		Global.blue_indicator.visible = false
		Global.blue_indicator.scale = Vector2.ONE  # resetle
	
	position = target_pos + Vector2(0, -250)
	
	tween.tween_property(self, "position", target_pos, 1.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
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

func blue_indicator_animation() -> void:
	# ayrı bir coroutine gibi çalışıyor
	blue_indicator_active = true
	_run_blue_indicator_loop()

func _run_blue_indicator_loop() -> void:
	# sonsuz değil, flag true olduğu sürece dönüyor
	await get_tree().process_frame  # bir frame bekle, yoksa recursive anında patlar
	while blue_indicator_active:
		var t = create_tween()
		t.tween_property(Global.blue_indicator, "scale", Vector2(2.1, 2.1), 0.1)
		t.tween_property(Global.blue_indicator, "scale", Vector2(1.9, 1.9), 0.1)
		await t.finished
func _on_shake_timeout():
	# Timer süresi doldu = artık basılmıyor, kuyruk sıfırlansın
	shake_queue.clear()
