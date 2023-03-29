extends Node2D

onready var myBeam = $Line2D
onready var end = $End
onready var rayCast = $RayCast2D

export var rotation_speed : float = 0.01



var myPlayer
func _ready():
	get_node("End/Particles2D").emitting = true
	$End/Particles2D.position = Vector2.ZERO
	myPlayer = get_tree().get_nodes_in_group("Player")[0]
	myBeam.position = Vector2.ZERO	
	myBeam.set_point_position(0, Vector2.ZERO)
	$Particles2D.position = Vector2.ZERO

func _physics_process(delta):
	var impact_point : Vector2 = rayCast.get_collision_point()
	end.global_position = impact_point
	myBeam.set_point_position(1,end.position)
	$Particles2D.global_position = (global_position + end.global_position) / 2
	$Particles2D.process_material.emission_box_extents.x = (end.global_position - global_position).length() / 2.5
	rotate(rotation_speed * delta)
	if rayCast.get_collider().is_in_group("Player"):
		myPlayer.death()
