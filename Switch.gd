extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var area = get_node("Area2D")
onready var anim = get_node("AnimatedSprite")
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(not area.get_overlapping_bodies().empty()):
		anim.frame = 0
	else :
		anim.frame = 1

	
	
	pass
