extends Node2D

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_SPACE:
		pressedSpace()

func pressedSpace():
	# Cambia la escena cuando se presiona espacio
	get_tree().change_scene("res://Main.tscn")
