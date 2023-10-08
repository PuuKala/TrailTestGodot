extends Node2D

@export var starCount = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	# Spawn all the stars by duplicating the ZoomingStar node
	for i in range(starCount):
		add_child(get_node("ZoomingStar").duplicate())

# Empty process function just to get rid of a warning
func _process(_delta):
	pass
