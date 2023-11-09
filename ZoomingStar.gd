## ZoomingStar.gd
# Extends CharacterBody2D just to use velocity. No collisioin nor other
# character movement specific functionalities are used.
extends CharacterBody2D

@export var max_speed = 200
@export var acceleration = 2

## Time to wait until acceleration starts
@export var start_delay_sec = 2

## Time to accelerate and move until deceleration
@export var move_time_sec = 5

## Direction of the movement. 1 is down, -1 is up.
@export var direction = 1

signal signal_decelerating
signal signal_stopped

var speed = 0
enum State {WAIT, ACCELERATE, DECELERATE}
var current_state = State.WAIT
var timer

func _ready():
	# Randomize position
	position.x = randi_range(0, int(get_viewport_rect().size.x))
	position.y = randi_range(-max_speed, get_viewport_rect().size.y + max_speed)
	
	# Init timer in code, we want to control the starting and time of the timer
	$Timer.connect("timeout", _on_timer_timeout)
	$Timer.one_shot = true
	$Timer.start(start_delay_sec)

func _physics_process(_delta):
	# State machine: Wait, accelerate or decelerate object
	#print("Current state: ", current_state)
	match current_state:
		State.WAIT:
			speed = 0
		State.ACCELERATE:
			speed = speed + acceleration
			if speed > max_speed:
				speed = max_speed
		State.DECELERATE:
			speed = speed - acceleration
			if speed < 0:
				speed = 0
				signal_stopped.emit()
				current_state = State.WAIT
	
	velocity.y = speed * direction
	move_and_slide()
	
	# Randomize the next position if the object goes offscreen
	if direction > 0:
		if position.y > get_viewport_rect().size.y + max_speed:
			get_node("Trail").clear_points()
			position.y = -max_speed
			position.x = randi_range(0, int(get_viewport_rect().size.x))
	else:
		if position.y < -max_speed:
			get_node("Trail").clear_points()
			position.y = get_viewport_rect().size.y + max_speed 
			position.x = randi_range(0, int(get_viewport_rect().size.x))


func _on_timer_timeout():
	# Move to the next state when timer timeouts. Also, restart the timer with 
	# time according to the state.
	if current_state == State.WAIT:
		current_state = State.ACCELERATE
		$Timer.start(move_time_sec)
	elif current_state == State.ACCELERATE:
		current_state = State.DECELERATE
		signal_decelerating.emit()
