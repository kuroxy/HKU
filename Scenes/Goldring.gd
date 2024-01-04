extends Area2D

var hide = false

@export var min_time = 7
@export var max_time = 15

@export var particle = preload("res://Scenes/Explosition.tscn")

func spawn_particle():
	var part = particle.instantiate()
	get_parent().add_child(part)
	part.position = position


func _on_area_entered(area):
	if area.name == "Boomerang" and hide == false:
		spawn_particle()
		$AudioStreamPlayer2D.play()
		hide = true
		$Sprite2D.hide()
		var t = randf()*(max_time-min_time)+min_time
		$Timer.start(t)

func _on_timer_timeout():
	$Sprite2D.show()
	hide = false
	
