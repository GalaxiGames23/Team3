extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var time_stay_activ : float
export var time_before_next_activ : float

onready var area = get_node("Area2D")
onready var anim = get_node("AnimatedSprite")
var activ = 0
var timer_is_activ
var timer_before_next_activ
# Called when the node enters the scene tree for the first time.
func _ready():
	timer_is_activ = 0
	timer_before_next_activ = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(not area.get_overlapping_bodies().empty() and timer_before_next_activ == 0):
		activ = 1
	elif(time_stay_activ != 0 and activ):
		timer_is_activ += delta
		if(timer_is_activ > time_stay_activ):
			timer_is_activ = 0
			activ = 0
			timer_before_next_activ = time_before_next_activ
	elif(timer_before_next_activ != 0):
		timer_before_next_activ -= delta
		if timer_before_next_activ < 0:
			timer_before_next_activ = 0
	else :
		activ = 0

	anim.frame = activ
	
	pass
