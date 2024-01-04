extends CharacterBody2D


@export var SPEED = 300.0
@export var boomerang_dodge_max = 1


var selected_tool = -1
var selected_tools = ["Fishing Rod", "Boomerang", "Marbles"]

var boomerang_scene = preload("res://Scenes/Boomerang.tscn")
var boomerang_dodge = 0

var dobber_scene = preload("res://Scenes/dobber.tscn")
var dobber_object = null
var dobber_recall = false



var has_boomerang = true

var anim : AnimationPlayer

func _ready():
	anim = $AnimationPlayer

func _physics_process(delta):
	
	if boomerang_dodge >= 0:
		boomerang_dodge-=delta
	
	# Get the input direction and handle the movement/deceleration.
	var strafe = Input.get_axis("Left", "Right")
	var forwards = Input.get_axis("Forward", "Backwards")
	
	# Setting the velocity
	if strafe:
		velocity.x = strafe
	else:
		# Friction calculation
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Setting the velocity
	if forwards:
		velocity.y = forwards
	else:
		# Friction calculation
		velocity.y = move_toward(velocity.x, 0, SPEED)
	
	if velocity.length() > 0:
		rotation = velocity.angle()
		rotation_degrees = rotation

		# Play walking animation when moving
		if not anim.is_playing():
			anim.play("Move")
	else:
		# Stop the walking animation when not moving
		anim.stop()

	# Normalizing Velocity is used to make sure the movement in all the directions is the same speed
	velocity = velocity.normalized() * SPEED

	move_and_slide()

func shoot_boomerang():
	var boomerang = boomerang_scene.instantiate()
	var shoot_rotation = position.angle_to_point(get_global_mouse_position())
	
	get_parent().add_child(boomerang)
	boomerang.spawn(self,shoot_rotation)
	boomerang_dodge = boomerang_dodge_max
	return boomerang
	
	
func shoot_dobber():
	$CastingFish.pitch_scale = 1
	$CastingFish.play() 
	var dobber = dobber_scene.instantiate()
	var shoot_rotation = position.angle_to_point(get_global_mouse_position())
	var shoot_force = position.distance_to(get_global_mouse_position())
	get_parent().add_child(dobber)
	dobber.spawn(self,shoot_rotation,shoot_force)
	return dobber
	
func reel_dobber():
	$CastingFish.pitch_scale = .5
	$CastingFish.play() 
	dobber_object.reel()

func reeled_dobber():
	dobber_recall = false
	dobber_object = null


func boomerang_hit(boomerang):
	if boomerang_dodge <= 0:
		boomerang.queue_free()
		has_boomerang = true

func select_tool(toolindex):
	if toolindex > 3 or toolindex < 0:
		return
	$Player.frame = 4
	$Sprite2D.frame = toolindex
	$Sprite2D.show()
	$ToolTimer.start(1)
	selected_tool = toolindex


func select_tool_continue():
	$Sprite2D.hide()
	if selected_tool == 0:
		$Player.frame = 2
	elif selected_tool == 1:
		$Player.frame = 3
	elif selected_tool == 3:
		$Player.frame = 2
	
func _input(event):
	if event.is_action_released("Fire"):
		if selected_tool == 0 and dobber_object==null and dobber_recall == false:
			dobber_object = shoot_dobber()
		elif selected_tool == 0 and dobber_object!=null and dobber_recall == false:
			dobber_recall = true
			reel_dobber()
		
		if has_boomerang and selected_tool == 1:
			shoot_boomerang()
			has_boomerang = false


