extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const SPEED = 150
const JUMP_HEIGHT = -300

var qtt = 0
var motion = Vector2()
var boost = false
var is_immune = false  # Indica si Mario es inmune

onready var anim = $Personaje
onready var label = $Camera2D/CanvasLayer/Label
onready var immunity_timer = Timer.new()  # Temporizador para manejar la inmunidad

func _ready():
	add_child(immunity_timer)
	immunity_timer.connect("timeout", self, "_end_immunity")

func _physics_process(delta):
	motion.y += GRAVITY
	if Input.is_action_pressed("ui_right"):
		if boost:
			anim.play("altoDefault")
		else:
			anim.play("default")
		if Input.is_key_pressed(KEY_A):
			motion.x = SPEED * 1.5
		else:
			motion.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		if boost:
			anim.play("altoIzquierda")
		else:
			anim.play("izquierda")
		if Input.is_key_pressed(KEY_A):
			motion.x = -SPEED * 1.5
		else:
			motion.x = -SPEED
	else:
		anim.frame = 0
		anim.stop()
		motion.x = 0

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
			if motion.x > 0:
				if boost:
					anim.play("altoSalto")
				else:
					anim.play("salto")
			elif motion.x < 0:
				if boost:
					anim.play("altoSaltoIzquierda")
				else:
					anim.play("saltoIzquierda")
	motion = move_and_slide(motion, UP)

	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.name.begins_with("Goomba"):
			colisioGoomba(collision)
		if collision.collider.name.begins_with("Coin"):
			collision.collider.queue_free()
		if collision.collider.name.begins_with("Box"):
			collisioCapsa(collision)
		if collision.collider.name.begins_with("Walls7"):
			collisioMeta()

func colisioGoomba(collision):
	var normal = collision.get_normal()
	if normal.y < -0.9:
		collision.collider.queue_free()
		motion.y = JUMP_HEIGHT
	elif abs(normal.x) > 0.5 and not is_immune:
		if boost:
			boost = false
			_start_immunity()
		else:
			_end_game()

func collisioCapsa(collision):
	var normal = collision.get_normal()
	if normal.y > 0.9:
		var box_sprite = collision.collider.get_node("Box")
		box_sprite.play("used")
		if collision.collider.name == "Box2":
			boost = true
		else:
			qtt += 1
			label.text = "Coins: " + str(qtt)

func collisioMeta():
		get_tree().change_scene("res://WinScene.tscn")

func _start_immunity():
	is_immune = true
	immunity_timer.start(2) 

func _end_immunity():
	is_immune = false

func _end_game():
	get_tree().change_scene("res://GameOverScene.tscn")
