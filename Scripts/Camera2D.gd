extends Camera2D

var player = null
@export var camera_speed = 1
@export var boomerang_offset = Vector2.ZERO
var enable_offset = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null and get_tree().get_nodes_in_group("Player"):
		player = get_tree().get_nodes_in_group("Player")[0]
	
	if enable_offset:
		position = lerp(position,player.position+boomerang_offset,delta*camera_speed)
	else:
		position = lerp(position,player.position,delta*camera_speed)


func _on_boomerang_area_body_entered(body):
	if body.name == "Player":
		enable_offset = true
		
func _on_boomerang_area_body_exited(body):
	if body.name == "Player":
		enable_offset = false
