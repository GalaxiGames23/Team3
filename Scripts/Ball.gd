extends KinematicBody2D


export var speed = 100
export var velocity = Vector2.ZERO
export var direction = Vector2.ZERO
export var can_break_wall = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	direction = get_direction()
	velocity = direction * speed
	velocity=move_and_slide(velocity,Vector2.UP)

"""
Récupère l'input du joueur et fait tendre la direction de la balle vers la direction 
donnée par le joueur (rapproche de 1% par tick).
"""
func get_direction() -> Vector2:
	var input_dir = Vector2.ZERO
	var ret_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	if (direction == Vector2.ZERO):
		ret_dir = input_dir
	elif (direction.angle() == input_dir.angle + PI):
		ret_dir = Vector2(direction.x+1, direction.y)
	else:
		ret_dir = (direction*99 + input_dir)/100
	return ret_dir/abs(ret_dir)
	
