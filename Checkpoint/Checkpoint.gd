extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var allCheckpointExceptMe
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle")
	$NotActiveCheckpoint.visible = true
	$ActiveCheckpoint.visible = false
	allCheckpointExceptMe = get_tree().get_nodes_in_group("Checkpoint")
	allCheckpointExceptMe.erase(self)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func disactive_checkpoint():
	$ActiveCheckpoint.visible = false
	$NotActiveCheckpoint.visible = true
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	
func active_checkpoint():
	$ActiveCheckpoint.visible = true
	$NotActiveCheckpoint.visible = false
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	
	for otherCheckpoint in allCheckpointExceptMe:
		otherCheckpoint.disactive_checkpoint()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") :
		active_checkpoint()
		body.respawn_position = global_position
		
