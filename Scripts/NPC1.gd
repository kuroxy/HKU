extends Node2D


@export var dialogue_textures: Array[Texture2D] = []
@export var dialogue_maxindex: Array[int] = []
var current_dialogue_index = -1
var started_dialogue = -1
var wanna_talk_texture = null


@export var dialogueTime = 2.

var player = null


func dialogue_time():
	$DialogTimer.start(dialogueTime)

func start_dialogue(dialoguenumber):
	started_dialogue = dialoguenumber
	wanna_talk_texture = $Wannatalk.texture
	$Wannatalk.texture = dialogue_textures[dialoguenumber]
	$Wannatalk.hframes = dialogue_maxindex[dialoguenumber]
	$Wannatalk.frame = 0
	$DialogTimer.start(dialogueTime)
	
func dialogue():
	if $DialogTimer.is_stopped():
		
		if $Wannatalk.frame + 1 >= dialogue_maxindex[started_dialogue]:
			current_dialogue_index = -1
			started_dialogue = -1
			$Wannatalk.texture = wanna_talk_texture
			$Wannatalk.hframes = 1
			$Wannatalk.frame = 0
			$AnimationPlayer.play("Idle", -1)
			return
			
		$Wannatalk.frame+=1
		dialogue_time()
		
		
	
	
		




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player = get_tree().get_nodes_in_group("Player")
	if player and started_dialogue==-1:
		var dist = (player[0].position-position).length()
		if dist < 25:
			start_dialogue(0)
	
	if started_dialogue!=-1:
		dialogue()
		$AnimationPlayer.play("Talking", 0)
		
		if started_dialogue == 0 and $Wannatalk.frame == 1:
			if player:
				player[0].select_tool(0)
			

		
