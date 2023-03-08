extends KinematicBody2D


export var speed = 100
export var speed_to_break_wall = 400
export var velocity = Vector2.ZERO
export var direction = Vector2.ZERO
export var last_position = Vector2.ZERO

export var can_break_wall = false
var spawn_direction
var save_player
var myCamera

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = spawn_direction



func _physics_process(delta):
	if ((not can_break_wall) and (speed >= speed_to_break_wall)):
		can_break_wall = true
		$AnimationPlayer.play("CanBreakSpeedAnim")
	if (direction != Vector2.ZERO):
		speed += 1
	direction = get_direction()
	velocity = direction * speed
	if (velocity != Vector2.ZERO):
		last_position = global_position
		var new_velocity = move_and_slide(velocity,Vector2.UP)
		$CPUParticles2D2.global_position = (global_position + last_position) / 2
		if (new_velocity != velocity):
			velocity = new_velocity
			speed = velocity.length()
			direction = velocity.normalized()
		var obstacle_array = get_slide_count()
		if (obstacle_array):
			if (get_slide_collision(0).collider.is_in_group("Player")):
				save_player.respawn_player()
				myCamera.change_focus(save_player)
				queue_free()
				
			else:
				teleport_player()
			

#Teleport the player to the ball position
func teleport_player():
	save_player.global_position = global_position
	save_player.On_Ball_Touch()
	save_player._orientation(velocity)
	myCamera.change_focus(save_player)
	queue_free()

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
		ret_dir = input_dir
	elif (direction.angle() == input_dir.angle() + PI):
		ret_dir = Vector2(direction.x+1, direction.y)
	else:
		ret_dir = (direction*9 + input_dir)/10
	return ret_dir.normalized()
	
