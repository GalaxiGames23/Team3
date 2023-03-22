extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var activ = 0
var max_rotate = 90
var init_rot = 0
export var clockwise : bool
var type = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	clockwise = true
	init_rot = rotation_degrees
	if (clockwise):
		type = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if rotation_degrees < init_rot + type*90 and activ == 1:
		rotate(type*0.1)
	elif rotation_degrees > init_rot + type*90:
		rotation_degrees = init_rot + type*90
	if rotation_degrees > init_rot and activ == 0: 
		rotate(-type*0.1)
	elif rotation_degrees < init_rot:
		rotation_degrees = init_rot
	pass
