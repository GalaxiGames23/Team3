extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_focus

# Called when the node enters the scene tree for the first time.
func _ready():
	var p = get_tree().get_nodes_in_group("Player")
	current_focus = p[0]
	current_focus.myCamera = self

func _physics_process(delta):
	if current_focus:
		position = current_focus.position

#Change the target of the camera (between player and ball)
func change_focus(new_focus):
	current_focus = new_focus
