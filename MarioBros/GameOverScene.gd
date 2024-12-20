extends Node2D

func _ready():
	var timer = Timer.new()  
	add_child(timer)  
	timer.wait_time = 2
	timer.one_shot = true 
	timer.connect("timeout", self, "_on_timer_timeout") 
	timer.start() 

func _on_timer_timeout():
	get_tree().change_scene("res://Main.tscn") 
