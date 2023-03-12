extends StaticBody2D

# if hard is true, ball needs a high speed to destroy it, otherwise high speed won't work
export var hard : bool = true 
# Called when the node enters the scene tree for the first time.
func _ready():
	reset_objet()
	

func reset_objet():
	$Area2D/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false
	$WallToBeBroken.visible = true
	$BrokenWall.visible = false
	$WallBreaking.visible = false
	$Particles2D.emitting= false
	$ParticleBottom.emitting = false
	$ParticleTop.emitting = false
	$WallToBeBroken.position = Vector2.ZERO
	if hard:
		$WallToBeBroken.modulate = Color(0.70, 0.30, 0)
		$BrokenWall.modulate = Color(0.70, 0.30, 0)
		$WallBreaking.modulate = Color(0.70, 0.30, 0)
	else:
		$WallToBeBroken.modulate = Color(0.012, 0.24, 0.55)
		$BrokenWall.modulate = Color(0.012, 0.24, 0.55)
		$WallBreaking.modulate = Color(0.012, 0.24, 0.55)

#Function to call when the wall will be destroy
func break_wall(body):
	$AnimationPlayer.play("Break_Wall_Anim")
	emmit_particles(body)
	
#Function to call when the wall remain untouched
func not_break_wall():
	$AnimationPlayer.play("Not_Break_Wall_Anim")

#When the player hit the wall, without right speed, replace him next to wall
func replace_player(player: KinematicBody2D):
	var disttop = player.global_position.distance_to($ReplacePositionPlayerTop.global_position)
	var distbot = player.global_position.distance_to($ReplacePositionPlayerBottom.global_position)
	if (distbot < disttop):
		player.global_position += ($ReplacePositionPlayerBottom.global_position - global_position)
	else:
		player.global_position += ($ReplacePositionPlayerTop.global_position - global_position)


#When the ball enter in the area, if right speed, destroy the wall
func _on_Area2D_body_entered(body):
	if body.is_in_group("Ball") and ((body.can_break_wall_hard and hard) or (body.can_break_wall_soft and !hard)) :
		break_wall(body)
	elif  body.is_in_group("Ball") and ((!body.can_break_wall_hard and hard) or (!body.can_break_wall_soft and !hard)) :
		not_break_wall()
		replace_player(body)
		body.teleport_player()


func _on_Area2D_body_exited(body):
	if body.is_in_group("Ball"):
		emmit_particles(body)

func emmit_particles(body):
	var disttop = body.global_position.distance_to($ReplacePositionPlayerTop.global_position)
	var distbot = body.global_position.distance_to($ReplacePositionPlayerBottom.global_position)
	if (distbot < disttop):
		$ParticleBottom.global_position = body.global_position
		$ParticleBottom.emitting = true
	else:
		$ParticleTop.global_position = body.global_position
		$ParticleTop.emitting = true
