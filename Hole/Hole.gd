extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	var p = get_tree().get_nodes_in_group("Player")
	player = p[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



#When the player fall
func _on_Area2D_area_entered(area):
	player.start_falling(self)
