extends Line2D

export var length = 30
onready var parent = get_parent()




# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	clear_points()
	modulate.a = 1

func _physics_process(delta):
	add_point(parent.global_position)
	
	if (points.size() > length):
		remove_point(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
