extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var move_y : int
export var speed : float
onready var area = get_node("Area2D")

var activ = 0
var init_pos_x
var init_pos_y
# Called when the node enters the scene tree for the first time.
func _ready():
	init_pos_x = position.x
	init_pos_y = position.y
	pass # Replace with function body.

func _process(delta):

	if position.y > init_pos_y + move_y and activ == 1:
		position.y -= speed
	elif position.y < init_pos_y + move_y:
		position.y = init_pos_y + move_y
	if position.y < init_pos_y and activ == 0:
		position.y += speed
	elif position.y > init_pos_y:
		position.y = init_pos_y

	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
