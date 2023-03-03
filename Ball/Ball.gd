extends KinematicBody2D


export var speed = 100
export var velocity = Vector2.ZERO
export var direction = Vector2.ZERO
export var can_break_wall = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	if ((not can_break_wall) and (speed >= 200)):
		can_break_wall = true
	if (direction != Vector2.ZERO):
		speed += 1
	direction = get_direction()
	velocity = direction * speed
	if (velocity != Vector2.ZERO):
		var new_velocity = move_and_slide(velocity,Vector2.UP)
		if (new_velocity != velocity):
			print("bloqué")
			velocity = new_velocity
			speed = sqrt(velocity.x*velocity.x + velocity.y*velocity.y)
			direction = velocity/speed

"""
Récupère l'input du joueur et fait tendre la direction de la balle vers la direction 
donnée par le joueur (rapproche de 10% par tick).
"""
func get_direction() -> Vector2:
	var input_dir = Vector2.ZERO
	var ret_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	if (direction == Vector2.ZERO):
		#print(input_dir)
		ret_dir = input_dir
	elif (direction.angle() == input_dir.angle() + PI):
		ret_dir = Vector2(direction.x+1, direction.y)
	else:
		ret_dir = (direction*9 + input_dir)/10
	if ((ret_dir.x*ret_dir.x + ret_dir.y*ret_dir.y) == 0):
		return Vector2.ZERO
	else:
		return ret_dir/sqrt(ret_dir.x*ret_dir.x + ret_dir.y*ret_dir.y)
	
