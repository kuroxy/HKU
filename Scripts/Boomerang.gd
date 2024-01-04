extends Area2D


@export var spin_speed = 2.5


@export var duration = 1.0
@export var minspeed = 3
@export var maxspeed = 10

@export var returntimer = 3

var going_back = false
var player = null
var p_pos = null

func spawn(pl, rot):
	player = pl
	rotation = rot
	
	position = player.position
	p_pos = position
	
	
	
	$Recall.start(duration)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Boomerang.rotation_degrees += delta*360 * spin_speed
	p_pos=player.position
	
	
	
	if not $Recall.is_stopped():
		var progress = (duration-$Recall.time_left)/duration
		
		var speed = (maxspeed-minspeed)*(1-easeOutSine(progress))+minspeed
		$AudioStreamPlayer2D.pitch_scale = (1.2-.5)*(easeOutSine(1-progress))+.5
		position += Vector2(1, 0).rotated(rotation) * delta * speed
	else:
		if going_back == false:
			going_back = true
			$Speeding.start(returntimer)
		
		var progress = (returntimer-$Speeding.time_left)/returntimer
		
		var speed = (maxspeed-minspeed)*(1-easeOutSine(1-progress))+minspeed
		$AudioStreamPlayer2D.pitch_scale = (1.2-.5)*(1-easeOutSine(1-progress))+.5
		position += Vector2(1, 0).rotated(position.angle_to_point(p_pos)) * delta * speed

func _on_body_entered(body):
	if body.has_method("boomerang_hit"):
		body.boomerang_hit(self)
	
	
func easeOutSine(x): 
	return sin((x * PI) / 2)
