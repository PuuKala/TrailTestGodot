extends Node2D

@export var starCount = 10

var title_showing = false

const star_sprite2 = preload("res://Sprites/Sparkleframe2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Spawn all the stars by duplicating the ZoomingStar node
	for i in range(starCount):
		var new_node = get_node("ZoomingStar").duplicate()
		var rng = randi_range(0, 4)
		if rng < 3:
			pass
		else:
			new_node.get_node("Sprite2D").texture = star_sprite2
		add_child(new_node)

func _physics_process(delta):
	if !title_showing:
		return
	
	for i in $AnimatedTitle.get_children():
		var rng = randi_range(0, 60)
		if rng < 1:
			i.play("Sparkle")

func _on_zooming_star_signal_stopped():
	# Get called only once
	if title_showing:
		return
	title_showing = true
	$AnimatedTitle.visible = true
	var fade_in_tween = get_tree().create_tween()
	fade_in_tween.tween_property($AnimatedTitle, "modulate", Color(1,1,1,1), 2)
