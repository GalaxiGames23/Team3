extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

onready var beam = $Beam
onready var end = $End
onready var rayCast = $RayCast2D

func _physics_process(delta):
	end.global_position = rayCast.get_collision_point()
	if rayCast.get_collider() == KinematicBody2D :
		print("wololo") 
		pass
	beam.region_rect.end.x = end.position.length()
