extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func break_wall():
	$AnimationPlayer.play("Break_Wall_Anim")

func _on_Area2D_body_entered(body):
	if body.is_in_group("Ball") and body.can_break_wall:
		break_wall()
