extends Node2D

onready var switch
onready var actors
var length
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	actors = get_children()
	for i in range(get_child_count()):
		if(actors[0].name == "Switch"):
			switch = actors.pop_at(i)
	length = actors.size()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(length):
		actors[i].activ = switch.activ
	pass
