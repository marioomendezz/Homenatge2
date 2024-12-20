extends KinematicBody2D


const UP = Vector2(0, -1)
const GRAVITY = 20


var SPEED = -60
var motion = Vector2()
onready var anim = $Enemigo

func _physics_process(delta):
	motion.y += GRAVITY
	anim.play("default")
	motion.x = SPEED
	
	for i in range(get_slide_count()):  
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		if collision.collider.name.begins_with("Mario"):
			if  abs(normal.x) > 0.5:
				_end_game()
	motion = move_and_slide(motion, UP)		

func disappear():
	queue_free()  

func _end_game():
	get_tree().change_scene("res://GameOverScene.tscn")  # Cambia a la escena de Game Over
