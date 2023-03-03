extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false
	$WallVert3212.visible = true
	$Particles2D.emitting= false

#Function to call when the wall will be destroy
func break_wall():
	$AnimationPlayer.play("Break_Wall_Anim")
	
#Function to call when the wall remain untouched
func not_break_wall():
	$AnimationPlayer.play("Not_Break_Wall_Anim")

#When the player hit the wall, without enough speed, replace him next to wall
func replace_player(player: KinematicBody2D):
	var disttop = player.global_position.distance_to($ReplacePositionPlayerTop.global_position)
	var distbot = player.global_position.distance_to($ReplacePositionPlayerBottom.global_position)
	if (distbot < disttop):
		player.global_position += ($ReplacePositionPlayerBottom.global_position - global_position)
	else:
		player.global_position += ($ReplacePositionPlayerTop.global_position - global_position)


#When the ball enter in the area, if enough speed, destroy the wall
func _on_Area2D_body_entered(body):
	if body.is_in_group("Ball") and body.can_break_wall:
		break_wall()
	elif  body.is_in_group("Ball") and !body.can_break_wall:
		not_break_wall()
		replace_player(body)
		body.teleport_player()
