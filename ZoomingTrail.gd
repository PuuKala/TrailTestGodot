extends Line2D

var target
var point

## Which node to attach trail to
@export var targetPath: NodePath
@export var trailLenght = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(targetPath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Add a point to the line at the middle of the followed object
	global_position = Vector2(0,0)
	global_rotation = 0
	point = target.global_position
	add_point(point)
	
	# Remove points which exceed the set length
	while get_point_count() > trailLenght:
		remove_point(0)

