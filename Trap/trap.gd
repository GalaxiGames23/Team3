extends StaticBody2D

var stop : bool = false

func _ready():
	$CollisionShape2D.position=Vector2(-170,0)
	$CollisionShape2D2.position=Vector2(200,115)

func reset_objet():
	if (stop):
		$AnimationPlayer.play_backwards("block")
		stop=false

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and !stop:
		$AnimationPlayer.play("block")
		stop=true
