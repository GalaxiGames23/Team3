extends Node2D

onready var beam = $Beam
onready var end = $End
onready var rayCast = $RayCast2D

export var rotation_speed : float = 0.01

func _physics_process(delta):
	end.global_position = rayCast.get_collision_point()
	beam.scale.x = end.position.length()/64
	rotate(rotation_speed)
	if rayCast.get_collider().name == "Joueur":
		get_node("../Joueur").respawn_player()
