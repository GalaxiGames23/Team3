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
	
#When the ball enter in the area, if enough speed, destroy the wall
func _on_Area2D_body_entered(body):
	if body.is_in_group("Ball") and body.can_break_wall:
		break_wall()
	elif  body.is_in_group("Ball") and !body.can_break_wall:
		not_break_wall()
