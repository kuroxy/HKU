extends Area2D




@export var duration = 1.0
@export var minspeed = 50.
@export var maxspeed = 250.

@export var min_distance = 25.
@export var max_distance = 150.

@export var recall_speed = 150

@export var returntimer = 3



@export var exlam_delay = .5
@export var exlam_chance = .3

@export var exlam_min = .9
@export var exlam_max = 1.5



@export var delay_question_min = 3
@export var delay_question_max = 10
var delay_question_started = false

@export var question_min = 1
@export var question_max = 5


var working_speed = 0

var player = null
var p_pos = null

var movement_dir = Vector2.ONE

var reeling = false


var in_water = false

var fishable = false

var fish = false
var goldenfish = false


func spawn(pl, rot, force):
	player = pl
	movement_dir = Vector2(cos(rot),sin(rot))
	
	position = player.position
	p_pos = position
	
	working_speed = (max(min_distance,min(force,max_distance))/max_distance)*(maxspeed-minspeed)+minspeed

	$Stop.start(duration)
	
func reel():
	reeling = true
	fishable = false
	if not $ExlamTime.is_stopped():
		goldenfish = getfishtype()
		fish = true
		print(goldenfish)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Line2D.clear_points()
	$Line2D.add_point(Vector2(0,-1.5))
	$Line2D.add_point(player.position-position)
	p_pos=player.position
	
	
	if $Stop.is_stopped():
		fishable = in_water
	
	
	# movement fishing
	if not $Stop.is_stopped():
		fishable= false
		var progress = (duration-$Stop.time_left)/duration
		
		var speed = working_speed*(1-easeOutSine(progress))
		
		position += movement_dir * delta * speed
	elif reeling:
		if (position-player.position).length() < 5:
			player.reeled_dobber()
			queue_free()
		
		
		var direc = (player.position-position).normalized()
		$FishSprites.rotation = direc.angle()#+(randf()*2-1)*0 # fun idea looks too glitchy
		position += direc * delta * recall_speed
		
		
	# fishing logic
	
	
	if fishable:
		if not $ExlamTime.is_stopped():
			fishIcon(2)
		elif not $QuestionTime.is_stopped():
			fishIcon(1)
		else:
			fishIcon(0)
		questiontimer()
		exlamtimer()
	

	

func questiontimer():
	if $QuestionTimeDelay.is_stopped() and $QuestionTime.is_stopped() and delay_question_started==false:
		# make a new timer
		var t = randf()*(delay_question_max-delay_question_min)+delay_question_min
		$QuestionTimeDelay.start(t)
		delay_question_started = true
	elif $QuestionTimeDelay.is_stopped() and $QuestionTime.is_stopped():
		var t = randf()*(question_max-question_min)+question_min
		$QuestionTime.start(t)
		delay_question_started = false

func exlamtimer():
	# only works when questionmark exists
	if $QuestionTime.is_stopped():
		return
	
	if $ExlamDelay.is_stopped() and $ExlamTime.is_stopped():
		# random chance if fish bites
		if randf()<exlam_chance:
			var t = randf()*(exlam_max-exlam_min)+exlam_min
			$ExlamTime.start(t)
		else:
			$ExlamDelay.start(exlam_delay)


func fishIcon(phase):
	if phase==0:
		$FishingIcons.hide()
	elif phase==1:
		$FishingIcons.show()
		$FishingIcons.frame = 0
	elif phase==2:
		$FishingIcons.show()
		$FishingIcons.frame = 1

func getfishtype():
	# 10% for golden fish 30% for the other types
	var fishframe = 0
	var f = randf()
	if f<=.1:
		fishframe = 3
	elif f<=.4:
		fishframe = 1
	elif f<=.7:
		fishframe = 2
	$FishSprites.frame = fishframe
	$FishSprites.show()
	return fishframe==3

func easeOutSine(x): 
	return sin((x * PI) / 2)


func _on_area_entered(area):
	if area.name == "Fishing Area":
		in_water = true


func _on_area_exited(area):
	if area.name == "Fishing Area":
		in_water = false
