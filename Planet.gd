extends CharacterBody2D

var moving = false

func _physics_process(_delta):
	
	if !moving:
		return
	
	velocity.y = get_node("../ZoomingStar").velocity.y

	move_and_slide()


func _on_zooming_star_signal_decelerating():
	moving = true
